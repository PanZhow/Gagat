//
//  ArchiveTableViewController.swift
//  Gagat
//
//  Created by Tim Andersson on 2017-06-03.
//  Copyright © 2017 Cocoabeans Software. All rights reserved.
//

import UIKit
import Gagat

class ArchiveTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    // MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        apply(currentStyle)

		// If you have a scroll view/table view/collection view in your app, you need to tell
		// its pan gesture recognizer to wait for Gagat's pan gesture recognizer. If this
		// isn't done then the scroll view will prevent the two-finger pan events from reaching
		// Gagat.
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		tableView.panGestureRecognizer.require(toFail: appDelegate.transitionHandle.panGestureRecognizer)
    }

    // MARK: - UITableViewDelegate methods

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let archiveCell = cell as? ArchiveTableCellView else {
            return
        }

        archiveCell.apply(style: currentStyle.tableViewStyle.cellStyle)
    }

    // MARK: - Applying styles

	private struct Style {
		var navigationBarStyle: UIBarStyle
		var statusBarStyle: UIStatusBarStyle
		var tableViewStyle: TableViewStyle

		static let dark = Style(
			navigationBarStyle: .black,
			statusBarStyle: .lightContent,
			tableViewStyle: .dark
		)

		static let light = Style(
			navigationBarStyle: .default,
			statusBarStyle: .default,
			tableViewStyle: .light
		)
	}

	private struct TableViewStyle {
		var backgroundColor: UIColor
		var separatorColor: UIColor?
		var cellStyle: ArchiveTableCellView.Style

		static let dark = TableViewStyle(
			backgroundColor: UIColor(white: 0.15, alpha: 1.0),
			separatorColor: UIColor(white: 0.35, alpha: 1.0),
			cellStyle: .dark
		)

		static let light = TableViewStyle(
			backgroundColor: .groupTableViewBackground,
			separatorColor: UIColor(white: 0.81, alpha: 1.0),
			cellStyle: .light
		)
	}

	private var currentStyle: Style {
		return useDarkMode ? .dark : .light
    }

    fileprivate var useDarkMode = false {
        didSet { apply(currentStyle) }
    }

    private func apply(_ style: Style) {
        navigationController?.navigationBar.barStyle = style.navigationBarStyle
        UIApplication.shared.statusBarStyle = style.statusBarStyle

        tableView.backgroundColor = style.tableViewStyle.backgroundColor
        tableView.separatorColor = style.tableViewStyle.separatorColor
        apply(style.tableViewStyle.cellStyle, toCells: tableView.visibleCells)
    }

    private func apply(_ cellStyle: ArchiveTableCellView.Style, toCells cells: [UITableViewCell]) {
        for cell in cells {
            guard let archiveCell = cell as? ArchiveTableCellView else {
                continue
            }

            archiveCell.apply(style: cellStyle)
        }
    }

}


extension ArchiveTableViewController: GagatStyleable {

	func toggleActiveStyle() {
		useDarkMode = !useDarkMode
	}

}