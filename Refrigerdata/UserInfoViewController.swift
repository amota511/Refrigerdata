//
//  UserInfoViewController.swift
//  Refrigerdata
//
//  Created by amota511 on 8/13/16.
//  Copyright © 2016 Aaron Motayne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class UserInfoViewController: UIViewController, UITextFieldDelegate {
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.setTitleTextAttributes(["Color": "White"], forState: .Normal)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        return sc
    }()
    
    let inputsContainerView: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(handleRegisterLogin), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .Next
        tf.delegate = self
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 200, g: 200, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .Next
        tf.delegate = self
        return tf
    }()
    
    let emailSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 200, g: 200, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        tf.returnKeyType = .Go
        tf.delegate = self
        return tf
    }()
    
    let passwordSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 200, g: 200, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func textFieldShouldBeginEditing(state: UITextField) -> Bool {
        inputsContainerViewYAnchor?.active = false
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -100).active = true
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleRegisterLogin()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 100, g: 200, b: 100)
        
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        
        setloginRegisterSegmentedControl()
        setInputContainerView()
        setLoginRegisterButton()
        setNameTextField()
        setNameSeparatorView()
        setEmailTextField()
        setEmailSeparatorView()
        setPasswordTextField()
        setPaswordSeparatorView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if FIRAuth.auth()?.currentUser?.uid != nil {
            self.performSegueWithIdentifier("Login", sender: self)
        }else{
            print("User is not logged in")
        }

    }

    
    func setloginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegmentedControlYAnchor = loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12)
        loginRegisterSegmentedControlYAnchor?.active = true
        loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(view.frame.height * 0.06833).active = true
    }
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        //Change Height of inputContainerView
        inputsContainerViewHeightAnchor?.constant
            = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //Change height of nameTextField
        nameTextFieldHeightAnchor?.active = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        emailTextFieldHeightAnchor?.active = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        passwordTextFieldHeightAnchor?.active = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    var inputsContainerViewYAnchor: NSLayoutConstraint?
    var loginRegisterSegmentedControlYAnchor : NSLayoutConstraint?
    var loginRegisterButtonYAnchor: NSLayoutConstraint?
    
    func setInputContainerView(){
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerViewYAnchor = inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        inputsContainerViewYAnchor?.active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor,constant: -24).active = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(view.frame.height * 0.205)
        inputsContainerViewHeightAnchor?.active = true
    }

    func setLoginRegisterButton(){
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButtonYAnchor = loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12)
        loginRegisterButtonYAnchor?.active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(view.frame.height * 0.06833).active = true
        
    }
    
    func handleRegisterLogin(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
            
        }else{
            handleRegister()
        }
        
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, password = passwordTextField.text else{
            print("Form Is Not Valid")
            return
        }
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            print("Successfully logged in user")
            self.performSegueWithIdentifier("Login", sender: self)
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else{
            print("Form Is Not Valid")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error: NSError?) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            let ref = FIRDatabase.database().referenceFromURL("https://refrigerdata-ab823.firebaseio.com/")
            let usersReference = ref.child("Users").child(uid)
            let values = ["name" : name, "email" : email, "friges" : ["FrigeOne" : "RUHIUEHGI48UWRIJNEFDH", "FrigeTwo" : "IUH94HEIUDHIUBFD"]]
            usersReference.updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                print("Saved user successfully into firebase db")
            })
            print("Successfully registered user")
            self.performSegueWithIdentifier("Login", sender: self)
        })
    }
    
    func setNameTextField(){
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
    }
    
    func setNameSeparatorView(){
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
    
    }
    
    func setEmailTextField(){
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.active = true
        
    }
    
    func setEmailSeparatorView(){
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    
    func setPasswordTextField(){
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.active = true
        
    }
    
    func setPaswordSeparatorView(){
        passwordSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        passwordSeparatorView.topAnchor.constraintEqualToAnchor(passwordTextField.bottomAnchor).active = true
        passwordSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor{
    
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
