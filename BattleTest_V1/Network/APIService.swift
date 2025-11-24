
import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://quiz-api-movil-production.up.railway.app"
    
    private init() {}
    
    func fetchQuizzes(language: String, completion: @escaping (Result<[Subject], Error>) -> Void) {
        // SIEMPRE usar endpoint /es donde están todos los datos
        let urlString = "\(baseURL)/api/quizzes/es"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: -2)))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let remoteSubjects = try decoder.decode([RemoteSubject].self, from: data)
                // FILTRAR por idioma solicitado
                let subjects = remoteSubjects.map { $0.toLocalSubject(filterLanguage: language) }
                
                DispatchQueue.main.async {
                    completion(.success(subjects))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

struct RemoteSubject: Codable {
    let id: String
    let name: String
    let icon: String
    let color: String
    let quizzes: [RemoteQuiz]
    
    func toLocalSubject(filterLanguage: String) -> Subject {
        // FILTRAR quizzes por idioma
        let filteredQuizzes = quizzes.filter { $0.language == filterLanguage }
        
        let localQuizzes = filteredQuizzes.map { remoteQuiz in
            Quiz(
                id: remoteQuiz.id,
                title: remoteQuiz.title,
                subjectId: remoteQuiz.subjectId,
                minQuestionsNumber: remoteQuiz.minQuestionsNumber,
                language: remoteQuiz.language,
                questions: remoteQuiz.questions
            )
        }
        
        return Subject(
            id: id,
            name: name,
            icon: icon,
            color: color,
            quizzes: localQuizzes
        )
    }
}

struct RemoteQuiz: Codable {
    let id: String
    let title: String
    let subjectId: String
    let minQuestionsNumber: Int
    let language: String
    let questions: [Question]
}
