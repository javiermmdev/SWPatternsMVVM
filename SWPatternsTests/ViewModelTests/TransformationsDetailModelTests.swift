@testable import SWPatterns
import XCTest

// Mock para un escenario exitoso de GetSingleTransformationUseCase
private final class SuccessGetSingleTransformationUseCaseMock: GetSingleTransformationUseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void) {
        // Creamos una transformación de ejemplo para devolver
        let transformation = Transformation(id: transformationId, name: "Super Saiyan", description: "Increases power significantly", photo: "url_to_photo", hero: HeroIDContainer(id: heroId))
        completion(.success(transformation)) // Devolvemos la transformación exitosa
    }
}

// Mock para un escenario fallido de GetSingleTransformationUseCase
private final class FailedGetSingleTransformationUseCaseMock: GetSingleTransformationUseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation?, Error>) -> Void) {
        // Devolvemos un error simulando que no se encontró la transformación
        completion(.failure(APIErrorResponse.unknown("Transformation not found")))
    }
}

final class TransformationDetailViewModelTests: XCTestCase {

    // Prueba para el escenario exitoso de obtener una transformación
    func testGetSingleTransformationSuccess() {
        let successExpectation = expectation(description: "GetSingleTransformationSuccess") // Expectativa para el caso de éxito
        let loadingExpectation = expectation(description: "Loading") // Expectativa para el estado de carga
        
        let useCaseMock = SuccessGetSingleTransformationUseCaseMock() // Usamos el mock exitoso
        let sut = TransformationDetailViewModel(useCase: useCaseMock, heroId: "1234", transformationId: "1") // Inicializamos el ViewModel
        
        // Vinculamos los cambios de estado a las expectativas
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Cumplimos la expectativa de carga
            } else if case .success = state {
                successExpectation.fulfill() // Cumplimos la expectativa de éxito
            }
        }
        
        sut.load() // Iniciamos la carga
        waitForExpectations(timeout: 5) // Esperamos a que se cumplan las expectativas
        
        // Verificamos que la transformación se haya cargado correctamente
        XCTAssertNotNil(sut.transformation) // Comprobamos que la transformación no sea nil
        XCTAssertEqual(sut.transformation?.name, "Super Saiyan") // Verificamos que el nombre de la transformación sea correcto
    }
    
    // Prueba para el escenario fallido de obtener una transformación
    func testGetSingleTransformationFailure() {
        let errorExpectation = expectation(description: "GetSingleTransformationFailure") // Expectativa para el caso de fallo
        let loadingExpectation = expectation(description: "Loading") // Expectativa para el estado de carga
        
        let useCaseMock = FailedGetSingleTransformationUseCaseMock() // Usamos el mock fallido
        let sut = TransformationDetailViewModel(useCase: useCaseMock, heroId: "1234", transformationId: "1") // Inicializamos el ViewModel
        
        // Vinculamos los cambios de estado a las expectativas
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill() // Cumplimos la expectativa de carga
            } else if case .error = state {
                errorExpectation.fulfill() // Cumplimos la expectativa de error
            }
        }
        
        sut.load() // Iniciamos la carga
        waitForExpectations(timeout: 5) // Esperamos a que se cumplan las expectativas
        
        XCTAssertNil(sut.transformation) // Esperamos que no se haya cargado ninguna transformación
    }
}
