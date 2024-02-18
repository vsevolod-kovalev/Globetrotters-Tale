import Foundation
import OpenAI



let openAI = OpenAI(apiToken: "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")
let configuration_c = OpenAI.Configuration(token: "oyAPND99RrrokwibydpUT3BlbkFJujM7AZnvb1FTtZEljU6e", organizationIdentifier: "org-CLpwE3pzv2hEzxl6yZVTY2DN", timeoutInterval: 10.0)

func chat(profileText: String, model_s: Model) async -> String {
    let query = ChatQuery(model: model_s, messages: [.init(role: .user, content: profileText)])
    
    do {
        let result = try await openAI.chats(query: query)
        if let response = result.choices.first?.message.content {
            return response
        } else {
            return "No response received."
        }
    } catch {
        print("An error occurred: \(error)")
        return "An error occurred: \(error.localizedDescription)"
    }
}
