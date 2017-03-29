protocol NrPrimDelegate {
    func valueDidChange()
}

class NrPrim {
    var delegate: NrPrimDelegate?
    
    private var _value: Int?
    var value: Int? {
        get {
            return self._value
        }
        set(newValue) {
            self._value = newValue
        }
    }
    
    // Enumar cazurile de eroare ce pot aparea la check
    enum CheckError {
        case numberIsNil
        case negativeValue
        case zeroValue
        case tooBig
    }
    
    func check(withClosure completionHandler: (Bool?, CheckError?) -> Void) {
        if self._value != nil {
            
            switch self._value! {
            case let x where x == 0: return completionHandler(nil, .zeroValue)
            case let x where x < 0: return completionHandler(nil, .negativeValue)
            case let x where x <= 1: return completionHandler(false, nil)
            case let x where x <= 3: return completionHandler(true, nil)
            case let x where x > 1000000: return completionHandler(nil, .tooBig)
            default: break
            }
            
            // Linia: case let x where x == 0, aici x ia valoarea lui self._value! si apoi este verificat x == 0
            // in functie de valoarea x (adica self._value) apelez completionHandler-ul (functia closure)
            
            // al 2-lea parametru pentru completionHandler poate fi CheckError.zeroValue sau .zeroValue, este acelasi lucru.
            
            // (poate fi sters CheckError din fata cazului)
            // isi da automat seama ca .zeroValue este un case de-al enumerarii CheckError, deoarece noi am spus inca din antetul functiei ca tipul de date al lui completionHandler este (Bool?, CheckError?) -> Void
            
            for i in 2...(self._value!/2) {
                if self._value! % i == 0 {
                    return completionHandler(false, nil)
                }
            }
            
            return completionHandler(true, nil)
        }
        
        completionHandler(nil, .numberIsNil)
    }
}

class VerificarePrim: NrPrim {
    private var _status: Bool?
    var status: Bool? {
        return self._status
    }
    
    private var _statusMessage: String?
    var statusMessage: String? {
        get {
            return self._statusMessage
        }
    }
    
    // StatusMessages: Toate mesajele ce vor fi afisate
    // static let nume_constanta imi face o constanta in struct pe care o pot accesa de la exterior, fara static era nevoie de initializarea structurii astfel: StatusMessages().negativeValue
    // Cu static se elimina parantezele si se poate folosi fara initializare, astfel: StatusMessages.negativeValue
    
    struct StatusMessages {
        static let negativeValue = "Numar NEGATIV"
        static let isNotNumber = "Nu este numar"
        static let isPrime = "Numar PRIM"
        static let isNotPrime = "Numar NEPRIM"
        static let isZero = "Ai introdus ZERO"
        static let isTooBig = "Numarul este PREA MARE"
    }
    
    override var value: Int? {
        get {
            return super.value
        }
        set(newValue) {
            super.value = newValue
            
            // Implementez un closure care va primi din functia check doi parametri si va schimba valorile lui _status si _statusMessage
            // Observati ca self este "captat" in closure, functia are acces la self (self este VerificarePrim)
    
            self.check() { (status, error) in
                if error != nil
                {
                    // In functie de tipul erorii, _statusMessage primeste un mesaj din structura StatusMessages
                    // Nu este nevoie de default la switch deoarece luam in calcul, deja, toate valorile posibile pe care le poate lua error.
                    
                    switch error! {
                    case .negativeValue:
                        self._statusMessage = StatusMessages.negativeValue
                    case .numberIsNil:
                        self._statusMessage = StatusMessages.isNotNumber
                    case .zeroValue:
                        self._statusMessage = StatusMessages.isZero
                    case .tooBig:
                        self._statusMessage = StatusMessages.isTooBig
                    }
                } else if status != nil {
                    if status == true {
                        self._statusMessage = StatusMessages.isPrime
                    } else {
                        self._statusMessage = StatusMessages.isNotPrime
                    }
                }
                
                self._status = status
                // setez _status cu valorea primita ca parametru in closure
            }
            
            // Dupa ce am setat valoarea si statusul nou, pun in aplicare delegatul.
            // Apelez valueDidChange, implementat in ViewController
            
            self.delegate?.valueDidChange()
        }
    }
}

protocol BrainLogDelegate {
    func logDidAppend(newValue value: [String: Any])
}

class BrainLog: VerificarePrim {
    var logDelegate: BrainLogDelegate?
    
    private var _log = [[String: Any]]()
    var log: [[String: Any]] {
        get {
            return self._log
        }
    }
    
    static let UserDefaultsKey = "newLogHistory"
    
    override var value: Int? {
        get {
            return super.value
        }
        set(newValue) {
            super.value = newValue
            
            if self.status != nil {
                let newElement: [String: Any] = [
                    "value": self.value!,
                    "status": self.status!
                ]
                
                self._log.append(newElement)
                self.logDelegate?.logDidAppend(newValue: newElement)
            }
        }
    }
}
