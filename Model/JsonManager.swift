//
//  JsonManager.swift
//  FlankerExamination
//
//  Created by Daniel James on 12/7/19.
//  Copyright © 2019 Dom.Inspiration. All rights reserved.
//

import Foundation

//Standard Json handling

struct JSONData: Decodable {
    var candidate_id: Int
    var school_id: Int
    var test_time: Double
    var test_instance_id: Int
    var test_id: Int
    var test_entries: [[String: Int]]
}

struct School: Decodable {
    let id: Int
    let name: String
}

class ServerRequests: NSObject {
    
    static let shared = ServerRequests()
//"http://18.225.11.159:3000/apis/school/"
//"http://sparkerserver.research.utc.edu:3001/apis/school/"
    func fetchSchools(completion: @escaping (Result<[School], Error>) -> ()){
        let urlString = "http://sparkerserver.research.utc.edu:3001/apis/school/"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url){(data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("failed to fetch post", err)
                    return
                }
                guard let data = data else {return}
                
                do {
                    let SchoolsFetched = try JSONDecoder().decode([School].self, from: data)
                    completion(.success(SchoolsFetched))
                    print(SchoolsFetched)
                   } catch {completion(.failure(error))
                }
            }
        }.resume()
    }
    
    
    
    
    func createPost(candidate_id: Int, school_id: Int, test_time: Double, test_instance_id: Int, test_id: Int, test_entries: [[String: Any]], completion: (Error?) -> ()) {
        let urlString = "http://18.225.11.159:3000/apis/sparkerserver.research.utc.edu:3001"
        guard let url = URL(string: urlString) else {return}
        
        var urlrequest = URLRequest(url: url)
        urlrequest.httpMethod = "POST"
        
        let params = ["candidate_id": candidate_id, "school_id": school_id, "test_time": test_time, "test_instance_id":
            test_instance_id, "test_id": test_id, "test_entries": test_entries] as [String : Any]
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            urlrequest.setValue("Application/JSON", forHTTPHeaderField: "content-type")
            urlrequest.httpBody = data
            URLSession.shared.dataTask(with: urlrequest)  {(data, resp, err) in
                guard let data = data else {return}
                print(String(data:data, encoding: .utf8) as Any)
                }.resume()
        } catch {
            completion(error)
        }
   }
}

//need to send values
//isCorrect
//isCongruent
//isLeft
//responseTimes

