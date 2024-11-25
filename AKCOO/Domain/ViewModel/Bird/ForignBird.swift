//
//  ForignBird.swift
//  AKCOO
//
//  Created by 박혜운 on 11/18/24.
//

import Foundation

/// 물가를 기준하는 새
struct ForignBird: BirdModel {
  private let country: CountryProfile
  private let judgmentCriteria: CountryAverageJudgment

  init(
    country: CountryProfile,
    judgment: CountryAverageJudgment
  ) {
    self.country = country
    self.judgmentCriteria = judgment
  }
  
  var judgment: Bool { return judgmentCriteria.result == .buying }
  
  var name: String { return "\(country.name) 10년차" }
  var information: String { return "나는 \(country.name) 10년 차 짹짹이야! \(country.name)의 평균물가를 기준으로 너의 지출들을 판단해줄게!" }
  
  private var birdReaction: BirdReaction {
    let items = judgmentCriteria.standards
    let sortedItems = items.sorted { $0.amount < $1.amount }
    let average = judgmentCriteria.averageOfItems ?? 0.0
    let input = judgmentCriteria.userAmount
    
    // 값이 중복되는 경우를 제외한 기준들의 값
    let uniqueAmounts = Set(sortedItems.map { $0.amount })
    
    switch uniqueAmounts.count {
    // 중복된 값을 제외한 item이 1개일 때
    // 모든 amount가 동일하다면 기준 1개와 동일한 .weakYes 반환
    // item이 1개 미만인 경우는 없겠지만, 혹시 그런 경우의 기본값 제공.
    case ...1:
      return .weakYes
      
    // 중복된 값을 제외한 item이 2개일 때
    case 2:
      guard sortedItems.count >= 2 else { return .mediumYes }
      
      guard let minimumItem = sortedItems.first else { return .mediumYes }
      guard let maximumItem = sortedItems.last else { return .mediumYes }
      
      switch input {
      case ...minimumItem.amount:
        return .strongYes
      case ...average:
        return .mediumYes
      case ...maximumItem.amount:
        return .mediumNo
      case maximumItem.amount...:
        return .strongNo
      default:
        return .mediumYes
      }
      
    // item이 3개 이상일 때
    // FIXME: case 3... 을 추가하고 default는 별개로 두기
    default:
      guard sortedItems.count >= 3 else { return .mediumYes }
      
      guard let minimumItem = sortedItems.first else { return .mediumYes }
      guard let maximumItem = sortedItems.last else { return .mediumYes }
      
      if input == average { // 입력금액 == 평균
        return .mediumYes
      } else if input < average { // 입력금액 < 평균
        let lowerThanAverageItems = sortedItems
          .filter { $0.amount < average }
          .sorted { $0.amount < $1.amount }
        
        // 모든 amount가 동일하다면 기준 1개와 동일한 .mediumYes 반환
        let uniqueAmountsOfLowerThanAverageItems = Set(lowerThanAverageItems.map { $0.amount })
        guard let maximumOfLowerItems = lowerThanAverageItems.last else { return .mediumYes }
        
        switch uniqueAmountsOfLowerThanAverageItems.count {
        case ...1:
          switch input {
          case ...minimumItem.amount:
            return .strongYes
          case minimumItem.amount...average:
            return .mediumYes
          default:
            return .mediumYes
          }
        case 2...:
          switch input {
          case ...minimumItem.amount:
            return .strongYes
          case ...maximumOfLowerItems.amount:
            return .mediumYes
          case maximumOfLowerItems.amount...:
            return .weakYes
          default:
            return .mediumYes
          }
        default:
          return .mediumYes
        }
      } else { // 평균 < 입력금액
        let largerThanAverageItems = sortedItems
          .filter { $0.amount > average }
          .sorted { $0.amount < $1.amount }
        
        // 모든 amount가 동일하다면 기준 1개와 동일한 .mediumNo 반환
        let uniqueAmountsOfLargerThanAverageItems = Set(largerThanAverageItems.map { $0.amount })
        guard let minimumOfLargerItems = largerThanAverageItems.first else { return .mediumYes }
        
        switch uniqueAmountsOfLargerThanAverageItems.count {
        case ...1:
          switch input {
          case average...maximumItem.amount:
            return .mediumNo
          case maximumItem.amount...:
            return .strongNo
          default:
            return .mediumNo
          }
        case 2...:
          switch input {
          case ...minimumOfLargerItems.amount:
            return .weakNo
          case ...maximumItem.amount:
            return .mediumNo
          case maximumItem.amount...:
            return .strongNo
          default:
            return .mediumNo
          }
        default:
          return .mediumYes
        }
      }
    }
  }
  
  var opinion: String {
    ""
  }
}
