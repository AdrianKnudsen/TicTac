import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        setupSplashScreen()
    }
    
    // Function to setup the splash screen
    func setupSplashScreen() {
        let titleLabel = SKLabelNode(text: "Tic Tac Toe")
        titleLabel.fontSize = 65
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(titleLabel)

        let startButton = SKSpriteNode(color: .white, size: CGSize(width: 200, height: 50))
        startButton.name = "startButton"
        startButton.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(startButton)

        let startLabel = SKLabelNode(text: "Start Game")
        startLabel.fontSize = 25
        startLabel.fontColor = .black
        startLabel.verticalAlignmentMode = .center
        startLabel.horizontalAlignmentMode = .center
        startButton.addChild(startLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)

        if node.name == "startButton" || node.parent?.name == "startButton" {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let ticTacToeScene = TicTacToeScene(size: self.size)
            view?.presentScene(ticTacToeScene, transition: transition)
        }
    }
}
