//
// Created by Daniel Coleman on 5/17/20.
// Copyright (c) 2020 Daniel Coleman. All rights reserved.
//

import Foundation

protocol CitySearchResultModel: class {

    var titleText: String { get }
    var populationClass: PopulationClass { get }

    var tapCommand: OpenDetailsCommand { get }
}

class CitySearchResultModelImp: CitySearchResultModel {

    let titleText: String
    let populationClass: PopulationClass

    let tapCommand: OpenDetailsCommand

    init(searchResult: CitySearchResult, tapCommandFactory: OpenDetailsCommandFactory) {

        self.titleText = searchResult.name
        self.populationClass = CitySearchResultModelImp.populationClass(for: searchResult.population)

        self.tapCommand = tapCommandFactory.openDetailsCommand(for: searchResult)
    }

    static private func populationClass(for population: Int) -> PopulationClass {

        let allPopulations: [PopulationClass] = [PopulationClassSmall(), PopulationClassMedium(), PopulationClassLarge(), PopulationClassVeryLarge()]

        return allPopulations.first { populationClass in populationClass.range.contains(population) } ?? PopulationClassSmall()
    }
}

protocol PopulationClass {

    var range: Range<Int> { get }

    func equals(_ other: PopulationClass) -> Bool

    func accept<T, V: PopulationClassVisitor>(_ visitor: V) -> T where V.T == T
}

protocol PopulationClassVisitor {

    func visitSmall(_ class: PopulationClassSmall) -> T
    func visitMedium(_ class: PopulationClassMedium) -> T
    func visitLarge(_ class: PopulationClassLarge) -> T
    func visitVeryLarge(_ class: PopulationClassVeryLarge) -> T

    associatedtype T
}

struct PopulationClassSmall: PopulationClass {

    var range: Range<Int> { 0..<10000 }

    func equals(_ other: PopulationClass) -> Bool { other is PopulationClassSmall }

    func accept<T, V: PopulationClassVisitor>(_ visitor: V) -> T where V.T == T { visitor.visitSmall(self) }
}

struct PopulationClassMedium: PopulationClass {

    var range: Range<Int> { 10000..<100000 }

    func equals(_ other: PopulationClass) -> Bool { other is PopulationClassMedium }

    func accept<T, V: PopulationClassVisitor>(_ visitor: V) -> T where V.T == T { visitor.visitMedium(self) }
}

struct PopulationClassLarge: PopulationClass {

    var range: Range<Int> { 100000..<1000000 }

    func equals(_ other: PopulationClass) -> Bool { other is PopulationClassLarge }

    func accept<T, V: PopulationClassVisitor>(_ visitor: V) -> T where V.T == T { visitor.visitLarge(self) }
}

struct PopulationClassVeryLarge: PopulationClass {

    var range: Range<Int> { 1000000..<Int.max }

    func equals(_ other: PopulationClass) -> Bool { other is PopulationClassVeryLarge }

    func accept<T, V: PopulationClassVisitor>(_ visitor: V) -> T where V.T == T { visitor.visitVeryLarge(self) }
}