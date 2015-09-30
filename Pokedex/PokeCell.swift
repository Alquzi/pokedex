//
//  PokeCell.swift
//  Pokedex
//
//  Created by Mohammed Alkodaisoi on 9/20/15.
//  Copyright (c) 2015 Mohammed Alquzi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    //We need for the collection view cell the folwing:
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //We need also
    //To store pokemon object, so whenever new cells created we have an actual class we can use to hold the data, so we don't have to recopy like name, discripton..etc all over the place.
    var pokemon: Pokemon!
    
    //Create Rounded cell
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    //We need away to assighn above things at some point in the future
    //pass a function of configuring cell into the pokemon object
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
