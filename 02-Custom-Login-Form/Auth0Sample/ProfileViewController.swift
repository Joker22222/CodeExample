import UIKit
import Auth0

class ProfileViewController: Base, UICollectionViewDelegate, UICollectionViewDataSource, PermisoViewModelDelegate {
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnEmpresas: UIButton!
    @IBOutlet weak var destacados: UICollectionView!
    @IBOutlet weak var recientes: UICollectionView!
    @IBOutlet weak var lbNombreUsuario: UILabel!
    @IBOutlet weak var calendario: UICollectionView!
    var base: BaseController?
    var homeVM:  HomeViewModel?
    let url = "https://artescritorio.com/wp-content/uploads/2015/11/monsterball-icon-pack.png"
    var loginCredentials: Credentials!
    let idUsuario = UserDefaults.standard.string(forKey: "Name")
    var vcEditarPubli: EditarPublicacionViewController?
    var permisoViewModel: PermisoViewModel = PermisoViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.retrieveProfile()
        base = BaseController()
        destacados.delegate = self
        destacados.dataSource = self
        recientes.delegate = self
        recientes.dataSource = self
        calendario.delegate = self
        calendario.dataSource = self
        self.view.addSubview(destacados)
        self.view.addSubview(recientes)
        self.view.addSubview(calendario)
        btnEmpresas.addTarget(self, action: #selector(ProfileViewController.menu), for: .touchUpInside)
        lbNombreUsuario.text = idUsuario
        permisoViewModel.delegate = self
        stopAnimating()
    }
    
    // MARK: - Private
    
    override func viewWillAppear(_ animated: Bool) {
        startAnimating()
        homeVM = HomeViewModel()
        homeVM?.delegate = self
        homeVM?.getpublicaciones()
    }
    func menu(){
        base?.showActionSheet()
    }
    
    func setPermisos(){
        for i in 0...(permisoViewModel.listaPermisos?.count)! - 1 {
            UserDefaults.standard.set(permisoViewModel.listaPermisos?[i].limAlcanzado,forKey: permisoViewModel.listaPermisos![i].modulo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == destacados{
            if (homeVM?.listaPublicacionesDest != nil){
                return (homeVM?.listaPublicacionesDest?.count)!
            }else{
                return 0
            }
         }else if collectionView == recientes{
            if (homeVM?.listaPublicaciones != nil){
                return (homeVM?.listaPublicaciones?.count)!
            }else{
                return 0
            }
         }else {
            if (homeVM?.listaEventos != nil){
                return (homeVM?.listaEventos?.count)!
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == destacados{
            let cellDestacados = collectionView.dequeueReusableCell(withReuseIdentifier: "destacados", for: indexPath) as UICollectionViewCell
            let destacadosImage = cellDestacados.viewWithTag(1) as! UIImageView
            let destacadoTitulo = cellDestacados.viewWithTag(5) as! UILabel
            destacadosImage.image = nil
            destacadoTitulo.text = nil
            if (homeVM?.listaPublicacionesDest != nil){
                destacadosImage.downloadedFrom(link: (homeVM?.listaPublicacionesDest![indexPath.row].imagen)!)
                destacadoTitulo.text = homeVM?.listaPublicacionesDest![indexPath.row].titulo
            }
            return cellDestacados
       
        
        }else if collectionView == recientes{
            let cellRecientes = collectionView.dequeueReusableCell(withReuseIdentifier: "recientes", for: indexPath) as UICollectionViewCell
            let recientesImage = cellRecientes.viewWithTag(2) as! UIImageView
            let recintesTitulo = cellRecientes.viewWithTag(4) as! UILabel
            recientesImage.image = nil
            recintesTitulo.text = nil
            if (homeVM?.listaPublicaciones != nil){
                recientesImage.downloadedFrom(link: (homeVM?.listaPublicaciones![indexPath.row].imagen)!)
                recintesTitulo.text = homeVM?.listaPublicaciones![indexPath.row].titulo
            }
            return cellRecientes
       
        
        }else{
            let cellCalendario = collectionView.dequeueReusableCell(withReuseIdentifier: "calendario", for: indexPath) as UICollectionViewCell
    
            let calendarioTipo = cellCalendario.viewWithTag(6) as! UILabel
            let calendarioTitulo = cellCalendario.viewWithTag(7) as! UILabel
            let calendarioDescripcion = cellCalendario.viewWithTag(8) as! UILabel
            let calendarioFecha = cellCalendario.viewWithTag(9) as! UILabel
            
            if (homeVM?.listaEventos != nil){
    
                calendarioTipo.text = homeVM?.listaEventos![indexPath.row].tipo
                calendarioTitulo.text = homeVM?.listaEventos![indexPath.row].nombre
                calendarioDescripcion.text = homeVM?.listaEventos![indexPath.row].descripcion
                calendarioFecha.text = formatDate(dateString: (homeVM?.listaEventos![indexPath.row].fechaInicio)!)
            }
            return cellCalendario
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == recientes){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "editar publicacion") as! EditarPublicacionViewController
            vc.setPublicacion(pubicacionAux: (homeVM?.listaPublicaciones![indexPath.row])!)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }else if (collectionView == destacados){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "editar publicacion") as! EditarPublicacionViewController
            vc.setPublicacionDest(pubicacionAux: (homeVM?.listaPublicacionesDest![indexPath.row])!)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetalleEvento") as! DetalleDelEventoViewController
            vc.setEvento(evento: (homeVM?.eventos?.eventos[indexPath.row])!)
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }

    func formatDate (dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "es_AR")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: dateObj!).uppercased()
    }
}

extension ProfileViewController: HomeViewModelDelegate {
    func finishedGettingPublicacionesDest() {
        self.destacados.reloadData()
        homeVM?.getEventos()
    }
    
    func finishedGettingPublicaciones() {
        self.recientes.reloadData()
        homeVM?.getDestacadas()
    }
    
    func finishedGettingEventos() {
        self.calendario.reloadData()
        if !(UserDefaults.standard.bool(forKey: "Invitado")){
            permisoViewModel.getPaquetes()
        }else{
            stopAnimating()
        }
    }
    
    func finishedGettingEventosWithError(_ error: NSError) {
        
    }
    
    func finishGetingMisPermisos() {
        stopAnimating()
        setPermisos()
    }
}

extension UIImageView {
    func downloadedFrom(url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url)
    }
}
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
