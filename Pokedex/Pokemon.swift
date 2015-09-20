//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mohammed Alkodaisoi on 9/20/15.
//  Copyright (c) 2015 Mohammed Alquzi. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    //For getters
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    //initilizer to pass the obove data in, for creating new pokemon
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}