//
//  TicTacToeScene.swift
//  TicTac
//
//  Created by Adrian on 06/08/2024.
//

import Foundation
import SpriteKit

class TicTacToeScene: SKScene {
    var board: [[SKSpriteNode?]] = [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
    var currentPlayer: String = "X"
    var boardState: [[String]] = [["", "", ""], ["", "", ""], ["", "", ""]]
    var playerPiecesCount: [String: Int] = ["X": 0, "O": 0]
    var selectedPiece: SKLabelNode?
    var turnLabel: SKLabelNode!
    var highlightedSquare: SKSpriteNode?

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        drawBoard()
        setupTurnLabel()
    }
    
    // Function to draw the board
    func drawBoard() {
        let boardWidth = frame.width - 40
        let cellSize = boardWidth / 3
        let startX = frame.midX - boardWidth / 2
        let startY = frame.midY + boardWidth / 2

        for row in 0..<3 {
            for col in 0..<3 {
                let cell = SKSpriteNode(color: .gray, size: CGSize(width: cellSize - 10, height: cellSize - 10))
                cell.position = CGPoint(x: startX + CGFloat(col) * cellSize + cellSize / 2,
                                        y: startY - CGFloat(row) * cellSize - cellSize / 2)
                cell.name = "\(row),\(col)"
                addChild(cell)
                board[row][col] = cell
            }
        }
    }
    
    // Function to setup the turn label
    func setupTurnLabel() {
        turnLabel = SKLabelNode(text: "Player \(currentPlayer)'s Turn")
        turnLabel.fontSize = 50
        turnLabel.fontName = "Helvetica-Bold"
        turnLabel.fontColor = .black
        turnLabel.position = CGPoint(x: frame.midX, y: frame.midY + (frame.width / 2) + 50)
        addChild(turnLabel)
    }
    
    // Function to handle touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if let name = node.name, name.contains(",") {
                let coordinates = name.split(separator: ",").map { Int($0)! }
                let row = coordinates[0]
                let col = coordinates[1]
                
                if boardState[row][col] == "" && playerPiecesCount[currentPlayer]! < 3 {
                    placePiece(at: node.position, row: row, col: col)
                } else if let labelNode = node as? SKLabelNode, boardState[row][col] == currentPlayer {
                    selectPiece(at: labelNode, row: row, col: col)
                } else if selectedPiece != nil && boardState[row][col] == "" {
                    movePiece(to: (row, col))
                }
            }
        }
    }
    
    // Function to place a piece on the board
    func placePiece(at position: CGPoint, row: Int, col: Int) {
        let label = SKLabelNode(text: currentPlayer)
        label.fontSize = 100
        label.fontName = "Helvetica-Bold"
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = position
        label.name = "\(row),\(col)"
        addChild(label)
        
        boardState[row][col] = currentPlayer
        playerPiecesCount[currentPlayer]! += 1
        
        if checkWin(for: currentPlayer) {
            showGameOver(winner: currentPlayer)
        } else {
            updateTurn()
        }
    }
    
    // Function to select a piece on the board
    func selectPiece(at piece: SKLabelNode, row: Int, col: Int) {
        selectedPiece = piece
        highlightSquare(at: row, col: col)
    }
    
    // Function to highlight a square
    func highlightSquare(at row: Int, col: Int) {
        if let highlightedSquare = highlightedSquare {
            highlightedSquare.removeFromParent()
        }
        
        let cell = board[row][col]!
        let highlight = SKSpriteNode(color: .green, size: cell.size)
        highlight.position = cell.position
        highlight.zPosition = -1
        addChild(highlight)
        highlightedSquare = highlight
    }
    
    // Function to move a piece on the board
    func movePiece(to destination: (Int, Int)) {
        guard let selectedPiece = selectedPiece else { return }
        
        let sourceCoordinates = selectedPiece.name!.split(separator: ",").map { Int($0)! }
        let source = (sourceCoordinates[0], sourceCoordinates[1])
        
        if isMoveValid(from: source, to: destination) {
            boardState[destination.0][destination.1] = currentPlayer
            boardState[source.0][source.1] = ""
            
            selectedPiece.position = board[destination.0][destination.1]!.position
            selectedPiece.name = "\(destination.0),\(destination.1)"
            
            self.selectedPiece = nil
            if let highlightedSquare = highlightedSquare {
                highlightedSquare.removeFromParent()
            }
            
            if checkWin(for: currentPlayer) {
                showGameOver(winner: currentPlayer)
            } else {
                updateTurn()
            }
        }
    }
    
    // Function to update the turn label and switch the current player
    func updateTurn() {
        currentPlayer = (currentPlayer == "X") ? "O" : "X"
        turnLabel.text = "Player \(currentPlayer)'s Turn"
    }
    
    // Function to check if the current player has won
    func checkWin(for player: String) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if boardState[i][0] == player && boardState[i][1] == player && boardState[i][2] == player {
                return true
            }
            if boardState[0][i] == player && boardState[1][i] == player && boardState[2][i] == player {
                return true
            }
        }
        
        // Check diagonals
        if boardState[0][0] == player && boardState[1][1] == player && boardState[2][2] == player {
            return true
        }
        if boardState[0][2] == player && boardState[1][1] == player && boardState[2][0] == player {
            return true
        }
        
        return false
    }
    
    // Function to check if the move is valid
    func isMoveValid(from: (Int, Int), to: (Int, Int)) -> Bool {
        let dx = abs(from.0 - to.0)
        let dy = abs(from.1 - to.1)
        return (dx <= 1 && dy <= 1) && (dx + dy > 0)
    }
    
    // Function to show the game over screen
    func showGameOver(winner: String?) {
        let message = winner != nil ? "\(winner!) Wins!" : "It's a Draw!"
        let gameOverLabel = SKLabelNode(text: message)
        gameOverLabel.fontSize = 50
        gameOverLabel.fontName = "Helvetica-Bold"
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY - (frame.width / 2) - 50)
        addChild(gameOverLabel)
        
        let wait = SKAction.wait(forDuration: 2.0)
        let transition = SKAction.run {
            let newScene = TicTacToeScene(size: self.size)
            self.view?.presentScene(newScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
        }
        run(SKAction.sequence([wait, transition]))
    }
}
