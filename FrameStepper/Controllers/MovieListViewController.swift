//
//  MovieListViewController.swift
//  FrameStepper
//
//  Created by Kazuya Shida on 2017/10/30.
//  Copyright © 2017 mani3. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    let dispose = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    fileprivate var files = Variable<[URL]>([])

    let ext = ["mp4", "mov", "avi", "mkv"]

    private var moviePaths: [URL] {
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        do {
            let contents = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            let files = contents.filter { ext.contains($0.pathExtension) }
            return files
        } catch {
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        files.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { (_, item: URL, cell) in
                cell.textLabel?.text = item.lastPathComponent
                cell.detailTextLabel?.text = item.absoluteString
            }
            .disposed(by: dispose)

        tableView.rx.modelSelected(URL.self)
            .subscribe(onNext: { [weak self] (url) in
                self?.performSegue(withIdentifier: "MovieReaderSegue", sender: url)
            })
            .disposed(by: dispose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        files.value = moviePaths
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MovieReaderViewController, let url = sender as? URL {
            viewController.url = url
        }
    }
}
