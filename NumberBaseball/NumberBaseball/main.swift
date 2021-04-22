//
//  NumberBaseball - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import Foundation

var computerAnswers: [Int] = [Int]()
var gameCount: Int = 9

func isDuplicated(_ array: [Int]) -> Bool {
    var _array: [Int] = array
    
    for _ in 1...array.count {
        let element = _array.removeFirst()
        if _array.contains(element) { return true }
    }
    
    return false
}

func getIntArray(from: String?, separatedBy: String) -> [Int]? {
    guard let _from : String = from else { return nil }
    var result: [Int] = [Int]()
    
    for element in _from.components(separatedBy: separatedBy) {
        guard let integer = Int(element) else { return nil }
        result.append(integer)
    }
    
    return result
}

struct NumberBaseball {
    enum Message: String {
        case gameMenu = "1. 게임시작\n2. 게임종료\n원하는 기능을 선택해주세요 : "
        case inputAnswer = "숫자 3개를 띄어쓰기로 구분하여 입력해주세요.\n중복 숫자는 허용하지 않습니다.\n입력 : "
        case inputError = "입력이 잘못되었습니다"
    }
    
    func isUserWin(strikeCount: Int) -> Bool { return strikeCount == 3 }
    
    func isComputerWin() -> Bool { return gameCount == 0 }
    
    func generateRandomAnswers() -> [Int] {
        var randomAnswers: [Int] = [Int]()
        
        while randomAnswers.count < 3 {
            let randomAnswer: Int = Int.random(in: 1...9)
            if randomAnswers.contains(randomAnswer) { continue }
            randomAnswers.append(randomAnswer)
        }
        
        return randomAnswers
    }
    
    func getUserInput(toPrint: Message) -> String? {
        print(toPrint.rawValue, terminator: "")
        return readLine()
    }
    
    func isValidMenuInput(userInput: String?) -> Bool {
        guard let _userInput: String = userInput else {
            print(Message.inputError.rawValue)
            return false
        }
        guard let userMenuInput: Int = Int(_userInput) else {
            print(Message.inputError.rawValue)
            return false
        }
        
        switch userMenuInput {
        case 1: return true
        case 2: exit(0)
        default:
            print(Message.inputError.rawValue)
            return false
        }
    }
    
    func isValidGameInput(userInput: String?) -> Bool {
        guard let userGameInputs: [Int] = getIntArray(from: userInput, separatedBy: " ") else {
            print(Message.inputError.rawValue)
            return false
        }
        
        if userGameInputs.count != 3 {
            print(Message.inputError.rawValue)
            return false
        }
        
        for userGameInput in userGameInputs {
            if !(1...9).contains(userGameInput) {
                print(Message.inputError.rawValue)
                return false
            }
        }
        
        if isDuplicated(userGameInputs) {
            print(Message.inputError.rawValue)
            return false
        }
        
        return true
    }

    func getGameResult(_ userAnswers: [Int]) -> [Int] {
        var strikeCount: Int = 0
        var ballCount: Int = 0
        
        for index in 0..<userAnswers.count {
            if userAnswers[index] == computerAnswers[index] {
                strikeCount += 1
            } else if computerAnswers.contains(userAnswers[index]) {
                ballCount += 1
            }
        }
        
        return [strikeCount, ballCount]
    }
    
    func printGameResult(_ userAnswers: [Int], _ gameResult: [Int]) {
        print("\(gameResult[0]) 스트라이크, \(gameResult[1]) 볼")
        
        if isUserWin(strikeCount: gameResult[0]) {
            print("사용자 승리!")
            gameCount = 9
        } else {
            print("남은 기회 : \(gameCount)")
        }
        
        if isComputerWin() {
            print("컴퓨터 승리...!")
            gameCount = 9
        }
    }
    
    func startGame() {
        var userInput: String?
        
        if gameCount == 9 {
            computerAnswers = generateRandomAnswers()
            
            repeat {
                userInput = getUserInput(toPrint: Message.gameMenu)
            } while false == isValidMenuInput(userInput: userInput)
        }
        
        repeat {
            userInput = getUserInput(toPrint: Message.inputAnswer)
        } while false == isValidGameInput(userInput: userInput)
        guard let userAnswers = getIntArray(from: userInput, separatedBy: " ") else { return startGame() }
        
        gameCount -= 1
        let gameResult: [Int] = getGameResult(userAnswers)
        printGameResult(userAnswers, gameResult)
        
        if gameCount > 0 {
            startGame()
        }
    }
}

NumberBaseball().startGame()
