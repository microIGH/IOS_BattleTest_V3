//
//  QuizResult.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import Foundation

struct QuizResult: Codable {
    let quizId: String
    let subjectId: String
    let score: Int
    let totalQuestions: Int
    let penaltyCount: Int
    let completionTime: TimeInterval
    let date: Date
    let passed: Bool
    
    var scorePercentage: Float {
        return Float(score) / Float(totalQuestions) * 100
    }
    
    var scoreDisplay: String {
        return "\(score)/\(totalQuestions)"
    }
    
    init(session: QuizSession) {
        self.quizId = session.quiz.id
        self.subjectId = session.subject.id
        self.score = session.score
        self.totalQuestions = session.minQuestionsNumber
        self.penaltyCount = session.penaltyCount
        self.completionTime = Date().timeIntervalSince(session.startTime)
        self.date = Date()
        self.passed = Float(score) / Float(totalQuestions) >= 0.7 // 70% para aprobar
    }
    
    /// Genera texto motivacional para compartir
    /// Flujo: ORIGEN: Datos del resultado → PROCESO: Formatear mensaje localizado → DESTINO: String compartible
    func generateShareText() -> String {
        let emoji = passed ? NSLocalizedString("share_passed_emoji", comment: "") : NSLocalizedString("share_failed_emoji", comment: "")
        let status = passed ? NSLocalizedString("share_passed_status", comment: "") : NSLocalizedString("share_failed_status", comment: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        
        let percentageInt = Int(scorePercentage)
        
        let quizCompleted = NSLocalizedString("share_quiz_completed", comment: "")
        let gradeText = String(format: NSLocalizedString("share_grade", comment: ""), scoreDisplay, percentageInt)
        let correctAnswersText = String(format: NSLocalizedString("share_correct_answers", comment: ""), score, totalQuestions)
        let dateText = String(format: NSLocalizedString("share_date", comment: ""), dateString)
        let hashtags = NSLocalizedString("share_hashtags", comment: "")
        
        let shareText = """
        \(emoji) \(status)
        
        📚 \(quizCompleted)
        ✅ \(gradeText)
        📊 \(correctAnswersText)
        📅 \(dateText)
        
        \(hashtags)
        """
        
        return shareText
    }
}
