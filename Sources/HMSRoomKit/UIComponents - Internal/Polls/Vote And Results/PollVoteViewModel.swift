//
//  PollVoteViewModel.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK
import SwiftUI

class PollVoteViewModel: ObservableObject, Identifiable {
    let interactivityCenter: HMSInteractivityCenter
    var poll: HMSPoll
    var isAdmin = false
    var canViewResponses: Bool
    var startedByName: String = ""
    var userID: String
    
    @Published var endDate: Date?
    @Published var state: HMSPollState
    
    @Published var summary: PollSummaryViewModel?
    @Published var canEndPoll = false
    @Published var isFetching = false
    @Published var questions = [PollVoteQuestionViewModel]()
    private var currentTheme: HMSUITheme?
    
    var id: String {
        poll.pollID
    }
    
    var voteComplete: Bool {
        questions.first(where: { $0.canVote == true }) == nil
    }
    
    lazy var leaderBoardModel: PollLeaderboardViewModel = {
        PollLeaderboardViewModel(poll: poll, interactivityCenter: interactivityCenter, isAmdin: isAdmin)
    }()

    internal init(poll: HMSPoll, interactivityCenter: HMSInteractivityCenter, currentRole: HMSRole, peerList: [HMSPeer]) {
        self.poll = poll
        self.canViewResponses = (poll.rolesThatCanViewResponses.isEmpty || poll.rolesThatCanViewResponses.contains(currentRole)) && poll.category == .poll
        self.state = poll.state
        self.interactivityCenter = interactivityCenter
        if let startDate = poll.startedAt, poll.duration > 0 {
            self.endDate =  startDate.addingTimeInterval(TimeInterval(poll.duration))
        }
        self.startedByName = poll.createdBy?.name ?? ""
        self.userID = peerList.first(where: { $0.isLocal })?.customerUserID ?? ""
        setupObserver()
    }
    
    func updateResults() {
        questions.forEach { $0.updateResults() }
    }
    
    func setupObserver() {
        interactivityCenter.addPollUpdateListner { [weak self] updatedPoll, update in
            guard let self, updatedPoll.pollID == self.poll.pollID else { return }
            self.state = poll.state
            switch update {
            case .started:
                break
            case .resultsUpdated:
                self.updateResults()
            case .stopped:
                self.refreshQuestions()
                self.loadResults()
            @unknown default:
                break
            }
        }
    }
    
    func setupQuizUserSummary() {
        guard voteComplete else { return }
        
        var correctAnswers = 0
        var incorrectAnswers = 0
        if let questions = poll.questions {
            for question in questions {
                if question.isCorrect {
                    correctAnswers += 1
                } else {
                    incorrectAnswers += 1
                }
            }
        }
        
        let model = PollSummaryViewModel(items: [PollSummaryItemRowViewModel(items: [PollSummaryItemViewModel(title: currentTheme?.localized.correctAnsTitle ?? "", subtitle: "\(correctAnswers)"), PollSummaryItemViewModel(title: currentTheme?.localized.incorrectAnsTitle ?? "", subtitle: "\(incorrectAnswers)")])])
        summary = model
    }
    
    func setupQuizAdminSummary() {
        guard poll.state == .stopped, let pollResult = poll.result else { return }
        
        var correctAnswers = 0
        var incorrectAnswers = 0
        
        for question in pollResult.questions {
            correctAnswers += question.correctVotes
            incorrectAnswers += question.totalVotes - question.correctVotes - question.skippedVotes
        }
        
        
        let model = PollSummaryViewModel(items: [PollSummaryItemRowViewModel(items: [PollSummaryItemViewModel(title: currentTheme?.localized.correctAnsTitle.uppercased() ?? "", subtitle: "\(correctAnswers)"), PollSummaryItemViewModel(title: currentTheme?.localized.incorrectAnsTitle.uppercased() ?? "", subtitle: "\(incorrectAnswers)")])])
        summary = model
    }

    
    func setupSummaryIfNeeded() {
        switch (poll.category, isAdmin) {
        case (.quiz, false):
            setupQuizUserSummary()
            
        default:
            summary = nil
            break
        }
    }
    
    func endPoll(completion: @escaping (()->Void)) {
        interactivityCenter.stop(poll: poll) { [weak self] _, _ in
            self?.canEndPoll = false
        }
    }
    
    func fetchQuestions(completion: @escaping (()->Void)) {
        interactivityCenter.fetchPollQuestions(poll: poll) { _, error in
            completion()
        }
    }
    
    func loadQuestions() {
        if poll.questions != nil {
            refreshQuestions()
            return
        }
        
        isFetching = true
        fetchQuestions { [weak self] in
            guard let self = self else { return }
            self.isFetching = false
            
            refreshQuestions()
        }
    }
    
    func loadResults() {
        guard poll.state == .stopped else { return }
        
        if poll.result != nil {
            setupSummaryIfNeeded()
        }
        
        interactivityCenter.fetchPollResult(for: poll) { [weak self] _, error in
            self?.setupSummaryIfNeeded()
            self?.refreshQuestions()
        }
    }
    
    func load(currentTheme: HMSUITheme) {
        self.currentTheme = currentTheme
        loadQuestions()
        loadResults()
    }
    
    func refreshQuestions() {
        let count = poll.questions?.count ?? 0
        questions = poll.questions?.map { PollVoteQuestionViewModel(question: $0, count:count, poll: poll, canVote: !$0.voted && poll.state == .started, canViewResponses: canViewResponses) { [weak self] model in
            self?.addResponse(question: model)
        } } ?? []
    }
    
    func addResponse(question: PollVoteQuestionViewModel) {
        let selectedOptions = question.questionOptions
            .filter { $0.selected == true }
            .map { $0.option }
        guard !selectedOptions.isEmpty else { return }

        let resultBuilder = HMSPollResponseBuilder(poll: poll)
        resultBuilder.addResponse(for: question.question, options: selectedOptions, duration: Int(question.duration * 1000))
        
        interactivityCenter.add(response: resultBuilder) { _, error in
            question.canVote = !question.question.voted
        }
    }
}

extension HMSPollQuestion {
    public var selectedOptionIndexes: Set<Int> {
        guard let response = myResponses.last else {
            return Set()
        }
        let singleChoice = type == .singleChoice
        var selectedIndexes = Set<Int>()
        if singleChoice {
            selectedIndexes.insert(response.option)
        } else if let responseOptions = response.options {
            selectedIndexes.formUnion(responseOptions)
        }
        return selectedIndexes
    }
    
    public var correctOptionIndexes: Set<Int> {
        guard let answer = answer else {
            return Set()
        }
        let singleChoice = type == .singleChoice
        var selectedIndexes = Set<Int>()
        if singleChoice, let answerOption = answer.option {
            selectedIndexes.insert(answerOption)
        } else if let answerOptions = answer.options {
            selectedIndexes.formUnion(answerOptions)
        }
        
        return selectedIndexes
    }
    
    public var isCorrect: Bool {
        selectedOptionIndexes == correctOptionIndexes
    }
}
