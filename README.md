# lasker-ruby
A command line chess program written in Ruby.

### Introduction
This is a command line chess program based on the thought of the second World Chess Champion Emanuel Lasker. It is like most chess engines with the exception that piece evaluations are not calculated by the (centi)pawn but are calculated on a point system. Lasker gave his estimation of the value of the pieces in *Lasker's Manual of Chess* prior to the convention of valuing pieces relative to the value of the pawn.

Beyond the oddities of its calculations, it is a fairly standard engine. Boards are represented by bitboards, moves are generated from the bitboards first assuming an empty board and then finding blockers, moves are then represented as 24 bit encodings, and the engine makes use of the standard minimax algorithm with alpha-beta pruning.

### Install and Run
1. Clone the code from this repository.
2. Open your terminal.
3. Use the commands:
```shell
cd ~/path/to/lasker-ruby
ruby lasker.rb
```
4. Begin entering moves in either abbreviated or normal algebraic notation.
  - If you do not know algebraic notation [this Wikipedia article](https://en.wikipedia.org/wiki/Algebraic_notation_(chess)) gives a good overview.
  - Alternatively, and in the spirit of this engine, you can learn algebraic notation from *Lasker's Manual of Chess: New 21st Century Edition!* pages 30-31.
5. Press ctrl+c to quit.
   

### To Do
- [x] Board Representation
  - [x] Bitboards
    - [x] Attackboards
	- [x] Pieceboards
	- [x] Occupancyboards
	- [x] Moveboards
- [ ] Move Generation
  - [x] Normal Moves
    - [x] Sliding pieces
	- [x] Knight moves
	- [x] Pawn moves
	- [x] King moves
  - [x] Special Moves
    - [x] En passant
	- [x] Promotion
	- [x] Check
	- [x] Castling
  - [ ] Debugging (ongoing process)
- [ ] Algebraic Notation Parser
  - [x] Abbreviated Algebaric Notation
  - [x] Normal Algebraic Notation
  - [ ] Long Algebraic Notation
  - [x] Numeric Encoding to Algebraic
- [ ] Game Loop
  - [ ] Display Game
	- [x] Display Board
	- [ ] Display Moves
	- [ ] Display Who is Winning (engine dependent)
  - [ ] Game Logic
    - [x] Make move
	- [x] End game conditions
	- [ ] End game results
	  - [x] Checkmate
	  - [x] Stalemate
	  - [x] Draw due to insufficient material
	  - [ ] Draw by threefold repetition
- [ ] Main Menu
  - [ ] Play vs eval mode
  - [x] Human vs Human
  - [x] Human vs Computer
    - [x] Select color
- [ ] Chess Engine
  - [ ] Alpha-beta pruning
  - [ ] Piece Values
  - [ ] Heuristics
- [ ] Extras
  - [ ] Export games as pgn
  - [ ] Import games for analysis
  - [ ] Opening Book
  - [ ] Endgame Tablebases
  - [ ] Web GUI
  - [ ] Instantiate Unsigned Long Long in Ruby
