//
//  TabBarController.swift
//  Vocs
//
//  Created by Mathis Delaunay on 04/05/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import UIKit
import SQLite

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth().loadUserConnected { (user) in
            if user != nil {
                if (user!.isProfessor()) {
                    self.loadViewController(isProfessor: true)
                } else {
                    self.loadViewController(isProfessor: false)
                }
            } else {
                self.loadViewController(isProfessor: false)
            }
        }
    }
    func loadViewController(isProfessor : Bool) {
        var arrayViews : [UIViewController] = []
        let listController = ListesViewController()
        let exerciceController = ExercicesViewController()
        let controllerStudent : ClasseStudentController!
        if (isProfessor){
            arrayViews.append(self.createAViewController(controller: ClasseTeacherController(collectionViewLayout: UICollectionViewFlowLayout()), image: #imageLiteral(resourceName: "Classe")))
        } else {
            controllerStudent = ClasseStudentController(collectionViewLayout: UICollectionViewFlowLayout())
            controllerStudent.delegateUserChangeClass = listController
            arrayViews.append(self.createAViewController(controller: controllerStudent, image: #imageLiteral(resourceName: "Classe")))
        }
        arrayViews.append(self.createAViewController(controller: exerciceController, image: #imageLiteral(resourceName: "Manette")))
        arrayViews.append(self.createAViewController(controller: listController, image: #imageLiteral(resourceName: "Liste")))
        self.view.backgroundColor = .white
        self.viewControllers = arrayViews
        self.selectedIndex = 1
    }
    
    private func createAViewController(controller : UIViewController, image : UIImage) -> UINavigationController {
        let controller = controller
        controller.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: controller)
        navController.tabBarItem.image = image
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return navController
    }
}
