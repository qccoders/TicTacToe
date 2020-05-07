#pragma once
#include "SDL.h"
#include "Button.h"

class GameBoard {
public:
	GameBoard();
	~GameBoard();

	void Update();
	static GameBoard* instance;
	bool playerTurn;
	
	char playerPiece;
	char aiPiece;

	bool gameIsRunning;

	Button* OButton;
	Button* XButton;
	Button* BackButton;

	GameObject* WinSign;
	GameObject* TitleSign;

private:
	int boardState[3][3];
	int numberOfEmptySlots;
	const int X_STATE = 11;
	const int O_STATE = 12;

	void PlayerMove(int xpos, int ypos);
	void AIMove();
	bool PlacePiece(char piece, int xIndex, int yIndex);
	void SetMenu();
	void SetBoard();

	static void ChooseOPiece();
	static void ChooseXPiece();
	static void GoBack();

	void CheckWinPattern();
	bool CheckWinCondition(int sum);
};
