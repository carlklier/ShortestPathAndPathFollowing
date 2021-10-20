double startTimeA;
double stopTimeA;
int nodesExpandedA;
int maxOpenSetA;
int maxClosedSetA;
int maxTagA;
class AstarTag implements Comparable<AstarTag> {
  City node;
  
  float cfs;
  float heur;
  Road edge;
  
  AstarTag(City node, float cfs, float heur, Road edge) {
    this.node = node;
    this.cfs = cfs;
    this.heur = heur;
    this.edge = edge;
  }
  
  int compareTo(AstarTag o) {
    if(this.cfs + this.heur < o.cfs + o.heur)
      return -1;
    else if(this.cfs + this.heur > o.cfs + o.heur)
      return 1;
    else
      return 0;
  }
}


class Astar implements GraphSearch{
  Heuristic heuristic; 
  City goal;
  HashMap<City, AstarTag> tags;
  
  PriorityQueue<AstarTag> open;
  HashSet<City> closed;
  
  Astar(Heuristic heuristic) {
    this.heuristic = heuristic;
  }
  
  
  void reset(City start, City goal, HashMap<String, City> cities){
    startTimeA = System.currentTimeMillis();
    maxOpenSetA = 0;
    maxClosedSetA = 0;
    maxTagA = 0;
    nodesExpandedA = 0;
    
    this.goal = goal;
    tags = new HashMap<City,AstarTag>();
  
    open = new PriorityQueue<AstarTag>();
    closed = new HashSet<City>();
    
    for(City city: cities.values()){
      AstarTag tag = new AstarTag(city, Float.MAX_VALUE, Float.MAX_VALUE, null);
      tags.put(city, tag);
    }
    
    AstarTag tag = new AstarTag(start, 0.0f, heuristic.value(start, goal), null);
    tags.put(start, tag);
    open.add(tag);
    
    
  }
  
  void update(){
    
    if(open.size() > maxOpenSetA){
      maxOpenSetA = open.size();
    }
    if(closed.size() > maxClosedSetA){
      maxClosedSetA = closed.size();
    }
    if(tags.size() > maxTagA){
      maxTagA = tags.size();
    }
    
    if(!closed.contains(goal)){
      AstarTag tag = open.poll();
      nodesExpandedA++;
      if(tag == null){
        println("Open set returned a null tag");
        return;
      }
 
      for(Road edge : tag.node.outgoing) {
          AstarTag next_tag = tags.get(edge.end);
          if(next_tag.cfs > edge.distance + tag.cfs){
            
            next_tag.cfs = edge.distance + tag.cfs;
            next_tag.edge = edge;
            next_tag.heur = heuristic.value(edge.end, goal);
            tags.put(edge.end, next_tag);

            open.add(next_tag);
          }

      }
      closed.add(tag.node);
    }
    
  } // end update
  
  List<Road> shortestPath(){
    if(closed.contains(goal)) {
      stopTimeA = System.currentTimeMillis();
      System.out.println("time until shortest path found: " + (stopTimeA - startTimeA));
      System.out.println("Nodes Expaned after shortest path found: " + nodesExpandedA);
      System.out.println("maxOpenSet: " + maxOpenSetA);
      System.out.println("maxClosedSet: " + maxClosedSetA);
      System.out.println("maxTag: " + maxTagA);
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
