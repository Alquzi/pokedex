//
//  Pokemon.swift
//  Pokedex
//
//  Created by Mohammed Alkodaisoi on 9/20/15.
//  Copyright (c) 2015 Mohammed Alquzi. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    //Create getters for the above privat vars to be used in the Details view
    // Not possible for names and Ids to be empty because it's already initliazed
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    // In case of nil result. Good for not to cased crash
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    //initilizer to pass the obove data in, for creating new pokemon
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        //convenience for retriveing only wanted pokemon
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)"
    }
    
    func downloadPokemonDEtails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?,
            response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            
            //Print JSON 
            //Don't forget to unable http security issue
            //print(result.value.debugDescription)
            
            //We know always the key is string but the value coud be AnyObject(String, Int, Array ..etc)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                //Key String. Value String
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                //Key String. Vale Int
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                //Key is String. Value is Array of dictionaries of type string
                //Pass if has no types
                if let types = dict["types"] as? [Dictionary<String, String>]  where types.count > 0{
                    //print(types.debugDescription)
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                //Grap the description url from the origional JSON
                if let descriptionsArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionsArray.count > 0 {
                    if let url = descriptionsArray[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        //Download the data out of the nested url
                        Alamofire.request(.GET, nsurl).responseJSON { (request: NSURLRequest?,
                            response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
                            
                            if let nestedDescriptionDict = result.value as? Dictionary<String, AnyObject>
                            {
                                if let description = nestedDescriptionDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                         completed() //close the call whether there is data or not
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>]
                //Check if there any evolution
                    where evolutions.count > 0 {
                    
                        if let to = evolutions[0]["to"] as? String {
                            //Can't support mega pokemon
                            if to.rangeOfString("mega") == nil {
                    
                                //grap only the number of the next evolution from the string
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    //So .. assign
                                    self._nextEvolutionId = num
                                    self._nextEvolutionTxt = to
                                    
                                    //If there is level
                                    if let lvl = evolutions[0]["level"] as? Int {
                                        //assign .. and convert to string because it comes as Int
                                        self._nextEvolutionLvl = "\(lvl)"
                                    }
                                    
                                    print(self._nextEvolutionId)
                                    print(self._nextEvolutionTxt)
                                    print(self._nextEvolutionLvl)
                                }
                            }
                        }
                }
            }
        }
    }
}







