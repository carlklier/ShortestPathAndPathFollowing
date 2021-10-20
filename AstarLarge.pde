double startTimeAA;
double stopTimeAA;
int nodesExpandedAA;
int maxOpenSetAA;
int maxClosedSetAA;
int maxTagAA;
class AstarLarge implements GraphSearch{
  int numCities;
  City goal;
  HashMap<City, AstarTag> tags;
  
  PriorityQueue<AstarTag> open;
  HashSet<City> closed;
  
  
  void reset(City start, City goal, HashMap<String, City> cities){
    startTimeAA = System.currentTimeMillis();
    maxOpenSetAA = 0;
    maxClosedSetAA = 0;
    maxTagAA = 0;
    nodesExpandedAA = 0;
    
    this.goal = goal;
    numCities = cities.size();
    tags = new HashMap<City,AstarTag>();
  
    open = new PriorityQueue<AstarTag>();
    closed = new HashSet<City>();
    
    for(City city: cities.values()){
      AstarTag tag = new AstarTag(city, Float.MAX_VALUE, Float.MAX_VALUE, null);
      tags.put(city, tag);
    }
    
    AstarTag tag = new AstarTag(start, 0.0f, getHeuristicValue(numCities, 0), null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  int getHeuristicValue(int numCities, int lenPathSoFar){
    int log = (int)(Math.log(numCities) / Math.log(2));
    //println("log: " + log + " lenPathSoFar: " + lenPathSoFar);
    int result = log - lenPathSoFar;
    if(result > 0){
     return result;
    } else {
     return 0; 
    }
    
  } // end getHeuristicValue
  
  void update(){
    if(open.size() > maxOpenSetAA){
      maxOpenSetAA = open.size();
    }
    if(closed.size() > maxClosedSetAA){
      maxClosedSetAA = closed.size();
    }
    if(tags.size() > maxTagAA){
      maxTagAA = tags.size();
    }
    
    if(!closed.contains(goal)){
      AstarTag tag = open.poll();
      nodesExpandedAA++;
      
      if(tag == null){
        println("Open set returned a null tag");
        return;
      }
      for(Road edge : tag.node.outgoing) {
        //if(!closed.contains(edge.end)){
          AstarTag next_tag = tags.get(edge.end);
       
          if(next_tag.cfs > edge.distance + tag.cfs){
            
            next_tag.cfs = edge.distance + tag.cfs;
            next_tag.edge = edge;
            next_tag.heur = getHeuristicValue(numCities, lenPathSoFar(next_tag));
            tags.put(edge.end, next_tag);
            
            open.add(next_tag);
          }
      }
      closed.add(tag.node);
    }
    
  } // end update
  
  int lenPathSoFar(AstarTag tag){
    ArrayList<Road> path = new ArrayList<Road>();
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
    return path.size();
  }
  
  List<Road> shortestPath(){
    if(closed.contains(goal)) {
      stopTimeAA = System.currentTimeMillis();
      System.out.println("time until shortest path found: " + (stopTimeAA - startTimeAA));
      System.out.println("Nodes Expaned after shortest path found: " + nodesExpandedAA);
      System.out.println("maxOpenSet: " + maxOpenSetAA);
      System.out.println("maxClosedSet: " + maxClosedSetAA);
      System.out.println("maxTag: " + maxTagAA);
      ArrayList<Road> path = new ArrayList<Road>();
      
      AstarTag tag = tags.get(goal);
      
      while(null != tag.edge) {
        path.add(tag.edge);
        tag = tags.get(tag.edge.start);
      }
      
      return path;
    } else {
      return null;
    }
    
  } // end shortest path
  
  Collection<City> openSet(){
    if(null != open) {
      ArrayList<City> list = new ArrayList<City>();
    
      for(AstarTag tag : open)
        list.add(tag.node);
    
      return list;
    } else {
      return null;
    }
  } // end open set()
  
  Collection<City> closedSet(){
    return closed; 
  }
}
