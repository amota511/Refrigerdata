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
        sc.tintColor = UIColor.white
        sc.setTitleTextAttributes(["Color": "White"], for: .normal)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    let inputsContainerView: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 90, g: 190, b: 90)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    lazy var nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .next
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
        tf.returnKeyType = .next
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
        tf.isSecureTextEntry = true
        tf.returnKeyType = .go
        tf.delegate = self
        return tf
    }()
    
    let passwordSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 200, g: 200, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let refridgerdata: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lobster-Regular", size: 45)
        label.text = "Refrigerdata"
        label.textColor =  UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    func textFieldShouldBeginEditing(_ state: UITextField) -> Bool {
        inputsContainerViewYAnchor?.isActive = false
        inputsContainerViewYAnchor = inputsContainerView.topAnchor.constraint(equalTo: refridgerdata.bottomAnchor, constant: 35)
        inputsContainerViewYAnchor?.isActive = true
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            
        }

        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleRegisterLogin()
        return true
    }
    
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 100, g: 200, b: 100)
        
        view.addSubview(refridgerdata)
        setRefridgerdata()
        
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            self.performSegue(withIdentifier:"Login", sender: self)
            
        }else{
            print("User is not logged in")
            let tapOutsideOfTextField = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
            self.view.addGestureRecognizer(tapOutsideOfTextField)
        }
    }
    
    

    func setRefridgerdata(){
        
        refridgerdata.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        refridgerdata.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        refridgerdata.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5).isActive = true
        refridgerdata.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setloginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        loginRegisterSegmentedControlYAnchor = loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo:inputsContainerView.topAnchor, constant: -12)
        loginRegisterSegmentedControlYAnchor?.isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant:view.frame.height * 0.06833).isActive = true
    }
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Change Height of inputContainerView
        inputsContainerViewHeightAnchor?.constant
            = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Hack to fix name placeholder issue.
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            nameTextField.placeholder = ""
            name = nameTextField.text!
            nameTextField.text = ""
        }else {
            nameTextField.placeholder = "Name"
            nameTextField.text! = name
        }
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
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
        inputsContainerView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        inputsContainerViewYAnchor = inputsContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor)
        inputsContainerViewYAnchor?.isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo:view.widthAnchor,constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.205)
        inputsContainerViewHeightAnchor?.isActive = true
    }

    func setLoginRegisterButton(){
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        loginRegisterButtonYAnchor = loginRegisterButton.topAnchor.constraint(equalTo:inputsContainerView.bottomAnchor, constant: 12)
        loginRegisterButtonYAnchor?.isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant:view.frame.height * 0.06833).isActive = true
        
    }
    
    func handleRegisterLogin(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            print("Form Is Not Valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            print("Successfully logged in user")
            self.performSegue(withIdentifier: "Login", sender: self)
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else{
            print("Form Is Not Valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
            (user: FIRUser?, error: Error?) in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://refrigerdata-ab823.firebaseio.com/")
            let usersReference = ref.child("Users").child(uid)
            let values = [ "name" : name,
                           "email" : email,
                           "friges" : ["RUHIUEHGI48UWRIJNEFDH", "IUH94HEIUDHIUBFD"]]
                           as [String : Any]
            
            usersReference.updateChildValues( values as [NSObject : AnyObject], withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                print("Saved user successfully into firebase db")
            })
            print("Successfully registered user")
            self.performSegue(withIdentifier:"Login", sender: self)
        })
    }
    
    func setNameTextField(){
        nameTextField.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo:inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo:inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    func setNameSeparatorView(){
        nameSeparatorView.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo:nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
    
    }
    
    func setEmailTextField(){
        emailTextField.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo:nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setEmailSeparatorView(){
        emailSeparatorView.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo:emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
        
    }
    
    func setPasswordTextField(){
        passwordTextField.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo:emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setPaswordSeparatorView(){
        passwordSeparatorView.leftAnchor.constraint(equalTo:inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo:passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo:inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant:1).isActive = true
        
    }
    
    func dissmissKeyboard(){
        
        if nameTextField.isEditing || emailTextField.isEditing || passwordTextField.isEditing {
            inputsContainerViewYAnchor?.isActive = false
            inputsContainerViewYAnchor = inputsContainerView.centerYAnchor.constraint(equalTo:view.centerYAnchor)
            inputsContainerViewYAnchor?.isActive = true
            nameTextField.resignFirstResponder()
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            
            UIView.animate(withDuration: 1.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
        
//        if nameTextField.isEditing {
//            nameTextField.resignFirstResponder()
//            return
//        }else if emailTextField.isEditing {
//            emailTextField.resignFirstResponder()
//            return
//        }else if passwordTextField.isEditing {
//            passwordTextField.resignFirstResponder()
//        }
        
    }

}

extension UIColor{
    
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
