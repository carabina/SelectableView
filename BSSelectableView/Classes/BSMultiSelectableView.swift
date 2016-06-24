//
//  BSMultiSelectableView.swift
//  BSSelectableView
//
//  Created by Bartłomiej Semańczyk on 06/22/2016.
//  Copyright (c) 2016 Bartłomiej Semańczyk. All rights reserved.
//

@IBDesignable public class BSMultiSelectableView: BSSelectableView, UITableViewDataSource, UITableViewDelegate, BSTokenViewDataSource {
    
    @IBOutlet public var tokenField: BSTokenView!
    public var selectedOptions = [BSSelectableOption]()
    
    //MARK: - Class Methods
    
    //MARK: - Initialization
    
    //MARK: - Deinitialization
    
    //MARK: - Actions
    
    @IBAction public func switchButtonTapped(sender: UIButton) {
        
        setupViewAndDataSourceIfNeeded()
        tableView.delegate = self
        tableView.dataSource = self
        
        tokenField.dataSource = self
        
        expanded = !expanded
        tableView.reloadData()
    }
    
    //MARK: - Public
    
    public override func updateView() {
        
        selectedOptions.sortInPlace { $0.title.lowercaseString <= $1.title.lowercaseString }
        tokenField.reloadData()
        super.updateView()
    }
    
    //MARK: - Internal
    
    //MARK: - Private
    
    //MARK: - Overridden
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BSSelectableTableViewCellIdentifier, forIndexPath: indexPath) as! BSSelectableTableViewCell
        let option = options?[indexPath.row]
        
        cell.titleLabel.text = option?.title
        cell.accessoryType = .None
        cell.tintColor = BSSelectableView.tintColorOfSelectedOption
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let selectedOption = options?[indexPath.row] {
            
            options?.removeAtIndex(indexPath.row)
            selectedOptions.append(selectedOption)
            
            updateView()
            
            delegate?.multiSelectableView?(self, didSelectOption: selectedOption)
        }
    }
    
    //MARK: - ZFTokenFieldDataSource
    
    func lineHeightForTokenInField(tokenField: BSTokenView) -> CGFloat {
        return 30
    }
    
    func numberOfTokenInField(tokenField: BSTokenView) -> Int {
        return selectedOptions.count
    }
    
    func tokenField(tokenField: BSTokenView, viewForTokenAtIndex index: Int) -> UIView? {
        return delegate?.multiSelectableView?(self, tokenViewForOption: selectedOptions[index], atIndex: index)
    }
}