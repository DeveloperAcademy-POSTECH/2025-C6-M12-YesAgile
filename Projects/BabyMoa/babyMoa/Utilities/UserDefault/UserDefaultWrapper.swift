//
//  UserDefaultWrapper.swift
//  babyMoa
//
//  Created by keonheehan on 11/1/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // newValue가 nil일 경우 UserDefaults에서 해당 객체를 제거합니다.
            // 이렇게 하면 Optional 타입의 값을 nil로 설정할 때 발생할 수 있는 충돌을 방지할 수 있습니다.
            if case Optional<Any>.none = newValue as Any {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
    
    func remove() {
        userDefaults.removeObject(forKey: key)
    }
}
