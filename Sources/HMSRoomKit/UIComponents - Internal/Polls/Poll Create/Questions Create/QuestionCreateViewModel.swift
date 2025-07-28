//
//  QuestionCreateViewModel.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK
import SwiftUI

class QuestionCreateViewModel: ObservableObject, Identifiable {
    @Published var questions = [QuestionCreateModel]()
    @Published var showingAlert = false
    @Published var alertText = ""
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var pollModel: PollCreateModel
    
    internal init(pollModel: PollCreateModel) {
        self.pollModel = pollModel
    }
    
    func loadQuestions() {
        guard let poll = pollModel.createdPoll else {
            return
        }
        
        pollModel.interactivityCenter.fetchPollQuestions(poll: poll) { [weak self] poll, error in
            self?.refreshQuestions()
        }
    }
    
    func refreshQuestions() {
        guard let poll = pollModel.createdPoll, let pollQuestions = poll.questions, !pollQuestions.isEmpty else {
            addQuestion()
            return
        }
        
        for (index, question) in pollQuestions.enumerated() {
            let selOptStr = question.type.toDisplayString(currentTheme: currentTheme)
            let createModel = QuestionCreateModel(pollModel: pollModel, index: index + 1, count: pollQuestions.count, question: question, saved: true, currentTheme: currentTheme) { [weak self] questionModel in
                self?.saveQuestions(questionToSave: questionModel)
            } onDelete: { [weak self] questionModel in
                self?.deleteQuestion(questionToDelete: questionModel)
            }
            
            questions.append(createModel)
        }
    }
    
    func addQuestion() {
        let createModel = QuestionCreateModel(pollModel: pollModel, index: 0, count: 0, showAnswerSelection: pollModel.createdPoll?.category == .quiz, saved: false, currentTheme: currentTheme) { [weak self] questionModel in
            self?.saveQuestions(questionToSave: questionModel)
        } onDelete: { [weak self] questionModel in
            self?.deleteQuestion(questionToDelete: questionModel)
        }
        questions.append(createModel)
        
        reindex()
    }
    
    func reindex() {
        let newCount = questions.count
        for (index, question) in questions.enumerated() {
            question.index = index + 1
            question.count = newCount
        }
    }
    
    func deleteQuestion(questionToDelete: QuestionCreateModel) {
        if !questionToDelete.saved {
            let newQuestions = questions.filter { $0.index != questionToDelete.index }
            questions = newQuestions
            reindex()
            return
        }
        
        guard let poll = pollModel.createdPoll else { return }
        let newQuestions = questions.filter { $0.index != questionToDelete.index }
        let pollQuestions = buildQuestions(from: newQuestions)
        
        questionToDelete.loading = true
        pollModel.interactivityCenter.setPollQuestions(poll: poll, questions: pollQuestions) { [weak self] success, _ in
            questionToDelete.loading = false
            if success {
                self?.questions = newQuestions
                self?.reindex()
            }
        }
    }
    
    func buildQuestions(from models: [QuestionCreateModel]) -> [HMSPollQuestion] {
        guard let poll = pollModel.createdPoll else { return [] }
        
        let savedModels = models.filter({ !$0.editing })
        
        var pollQuestions = [HMSPollQuestion]()
        for (index, question) in savedModels.enumerated() {
            let builder = HMSPollQuestionBuilder()
                .withIndex(index + 1)
                .withType(question.type)
                .withTitle(question.text.trimmingCharacters(in: .whitespacesAndNewlines))
                .withWeight(weight: question.weight.isEmpty ? 0 : (Int(question.weight) ?? 0))
            
            for option in question.questionOptions {
                if poll.category == .quiz {
                    _ = builder.addQuizOption(with: option.text.trimmingCharacters(in: .whitespacesAndNewlines), isCorrect: option.selected)
                } else {
                    _ = builder.addOption(with: option.text.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
            pollQuestions.append(builder.build())
        }
        return pollQuestions
    }
    
    func saveQuestions(questionToSave: QuestionCreateModel) {
        guard validate(questionToSave: questionToSave), let poll = pollModel.createdPoll else { return }

        questionToSave.editing = false
        questionToSave.loading = true
        
        let pollQuestions = buildQuestions(from: questions)
        
        pollModel.interactivityCenter.setPollQuestions(poll: poll, questions: pollQuestions) { success, _ in
            questionToSave.loading = false
            if success {
                questionToSave.saved = true
            } else {
                questionToSave.editing = true
                questionToSave.saved = false
            }
        }
    }
    
    func validate(questionToSave: QuestionCreateModel) -> Bool {
        var result = true

        if questionToSave.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            result = false
            questionToSave.valid = false
        } else {
            questionToSave.valid = true
        }
        
        var answerSelected = false
        
        for option in questionToSave.questionOptions {
            questionToSave.optionsValid = true
            
            if option.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                result = false
                option.valid = false
                questionToSave.optionsValid = false
            } else {
                option.valid = true
            }
            
            if option.selected {
                answerSelected = true
            }
        }
        
        let isQuiz = questionToSave.pollModel.createdPoll?.category == .quiz
        if isQuiz && !answerSelected {
            questionToSave.answersSelected = false
            result = false
        } else {
            questionToSave.answersSelected = true
        }
        
        if isQuiz && (questionToSave.weight.isEmpty || (Int(questionToSave.weight) ?? 0) == 0) {
            questionToSave.weightSelected = false
            result = false
        } else {
            questionToSave.weightSelected = true
        }
        
        return result
    }
    
    func startPoll() {
        guard pollModel.createdPoll?.questions?.isEmpty == false else {
            alertText = currentTheme.localized.pollSaveError
            showingAlert = true
            return
        }
        pollModel.startPoll()
    }
}

extension HMSPollQuestionType {
    public func toDisplayString(currentTheme: HMSUITheme) -> String {
        switch self {
        case .singleChoice:
            return currentTheme.localized.singleChoiceTitle
        case .multipleChoice:
            return currentTheme.localized.multiChoiceTitle
        case .shortAnswer:
            return currentTheme.localized.shortAnsTitle
        case .longAnswer:
            return currentTheme.localized.longAnsTitle
        default:
            return ""
        }
    }
}
