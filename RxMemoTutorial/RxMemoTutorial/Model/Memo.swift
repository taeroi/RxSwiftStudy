//
//  Memo.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxDataSources
import CoreData
import RxCoreData

//tableView와 collectionView에 바인딩하는 속성을 제공
import RxDataSources

struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    //업데이트된 내용으로 새로운 메모 인스턴스를 생성할때 사용
    init(original: Memo, updatedContent: String){
        self = original
        self.content = updatedContent
    }
}

extension Memo: Persistable {
    
    public static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            
        }
    }
}
