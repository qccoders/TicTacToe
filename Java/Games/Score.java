package Games;

public class Score {
    int score =0;
    int wins;
    int loses;
    String name;

    public Score(){

        this.score = score;
    }
    public Score(int score){
        this.score = score;
        score = score + wins - loses;
    }
    public Score(int score, String name){
        this.score = score;
        this.name = name;
        score = score + wins - loses;
    }
    public void setScore(int s){
        score = s;
        score = score + wins;
    }

    public int getScore() {
        return score;
    }

    public void setLoses(int l){
        loses = l;
        loses = loses +1;
    }

    public int getLoses() {
        return loses;
    }

    public void setWins(int w){
        wins = w;
        wins = wins + 1;
    }

    public int getWins() {

        return wins;
    }

    public void setName(String n) {
        name = n;
    }

    public String getName() {
        return name;
    }
}
