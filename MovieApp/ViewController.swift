//
//  ViewController.swift
//  MovieApp
//
//  Created by Hamdy Youssef on 20/04/2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var moviesArray: [Movie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        moviesArray = [Movie]()
        
       let url = URL(string: "https://gist.githubusercontent.com/alanponce/d8a5e47b4328b5560fb610c5731de2bd/raw/b9f2a2b20d7d71f0e9c31adf40c7c83308809ac0/movies.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            print(data)
            print("data hase arrived successfuly")
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<Dictionary<String,Any>>
                
                for rowMovie in json {
                    let movieObj = Movie()
                    movieObj.title = rowMovie["title"] as? String
                    movieObj.image = rowMovie["image"] as? String
                    movieObj.rating = rowMovie["rating"] as? Double
                    movieObj.releaseYear = rowMovie["releaseYear"] as? Int
                    self.moviesArray?.append(movieObj)
                }
                
                for movie in self.moviesArray! {
                    print(movie.title)
                }
                
            }catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (moviesArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("###############---------------- enter cell ---------------- ###############")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

        cell.titleLabel.text = moviesArray![indexPath.row].title
        let url = URL(string: "https://images-cdn.ubuy.co.in/63ef0a397f1d781bea0a2464-star-wars-rogue-one-movie-poster.jpg")
        print(url)
        cell.movieImageView.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailsVC") as! DetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    


}

