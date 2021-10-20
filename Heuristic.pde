interface Heuristic {
  float value(City start, City goal);
}

class Manhattan implements Heuristic {
  float value(City start, City goal) {
    return abs(goal.drawx - start.drawx) + abs(goal.drawy - start.drawy);
  }
}
class Euclidean implements Heuristic{
    float value(City start, City goal){
      return (float)Point2D.distance(start.drawx, start.drawy, goal.drawx, goal.drawy);
    }
}  
class RandomConstant implements Heuristic{
 float value(City start, City end){
   return random(200, 1000);
 }
}
 
 class Zero implements Heuristic{
 float value(City start, City end){
   return 0.0f;
 }
}
