// The MIT License (MIT)
//
// Copyright (c) 2016 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

protocol AlbumsViewControllerDelegate: class {
    func albumsViewController(_ albumsViewController: AlbumsViewController, isSelected: Album) -> Bool
    func albumsViewController(_ albumsViewController: AlbumsViewController, didSelect: Album)
}

class AlbumsViewController: UITableViewController {
    weak var delegate: AlbumsViewControllerDelegate?
    
    fileprivate let folders: [Folder]
    
    init(folders: [Folder]) {
        self.folders = folders
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View life cycle
extension AlbumsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 101
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = true
        tableView.register(nib: UINib(nibName: "AlbumCell", bundle: Bundle.imagePicker), for: AlbumCell.self)
    }
}

// MARK: TableViewDatasource
extension AlbumsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: AlbumCell.self, for: indexPath)
        
        let album = folders[indexPath.section][indexPath.row]
        cell.update(for: album)
        if delegate?.albumsViewController(self, isSelected: album) ?? false {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
}

// MARK: TableViewDelegate
extension AlbumsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.albumsViewController(self, didSelect: folders[indexPath.section][indexPath.row])
    }
}
