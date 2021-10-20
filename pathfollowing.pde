abstract class Path extends GameObject {
  abstract PVector getPosition(float param);
  abstract float getParam(PVector position, float lastParam);
}


class PointPath extends Path {
  
  ArrayList<PVector> points = new ArrayList<PVector>();
  float scale = 1.0;
  float range = 2.0;
 
  void addPoint(PVector point) {
    points.add(point);
  }
  
  PVector getPosition(float param) {
    int index = round(param / scale);
    
    if(index < points.size())
      return points.get(index);
    else
      return points.get(points.size() - 1);
  }
  
  float getParam(PVector position, float lastParam) {
    int minIndex = round((lastParam - range) / scale);
    minIndex = max(minIndex, 0);
    
    int maxIndex = round((lastParam + range) / scale) + 1;
    maxIndex = min(maxIndex, points.size());
    
    float minDistance = Float.POSITIVE_INFINITY;
    float param = 0.0;
    
    for(int i=minIndex; i < maxIndex; ++i){
       float distance = PVector.sub(points.get(i), position).mag();
       
       if(distance < minDistance){
         minDistance = distance;
         param = scale * (float) i;
       }
    }
    
    return param;
  }
  
  void render() {
    fill(255,200,0);
    stroke(255,200,0);
    
    for(PVector point : points) {
      circle(point.x, point.y, 15);
    }
  }
}


class SteeringFollowing extends SteeringSeek {
 
  Path path;
  float epsilon = 1.0;
  float currentParam = 0.0;
  
  SteeringFollowing(PointPath path) {
    this.path = path; 
  }
  
  DynamicSteeringOutput getSteering(Kinematic character) {
    currentParam = path.getParam(character.position, currentParam);
    PVector target = path.getPosition(currentParam + epsilon);
    
    super.target = new Static(target, 0.);
    return super.getSteering(character);
  }
}
