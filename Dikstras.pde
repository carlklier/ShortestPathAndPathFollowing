import java.lang.System;
double startTime;
double stopTime;
int nodesExpanded;
int maxOpenSet;
int maxClosedSet;
int maxTag;
class DikstraTag implements Comparable<DikstraTag> {
  City node;
  
  float cfs;
  Road edge;
  
  DikstraTag(City node, float cfs, Road edge) {
    this.node = node;
    this.cfs = cfs;
    this.edge = edge;
  }
  
  int compareTo(DikstraTag o) {
    if(this.cfs < o.cfs)
      return -1;
    else if(this.cfs > o.cfs)
      return 1;
    else
      return 0;
  }
}


class Dikstras implements GraphSearch{
  City goal;
  HashMap<City, DikstraTag> tags;
  
  PriorityQueue<DikstraTag> open;
  HashSet<City> closed;
  
  void reset(City start, City goal, HashMap<String, City> cities){
    startTime = System.currentTimeMillis();
    maxOpenSet = 0;
    maxClosedSet = 0;
    maxTag = 0;
    nodesExpanded = 0;
    
    this.goal = goal;
    
    tags = new HashMap<City,DikstraTag>();
  
    open = new PriorityQueue<DikstraTag>();
    closed = new HashSet<City>();
    
    for(City city: cities.values()){
      DikstraTag tag = new DikstraTag(city, Float.MAX_VALUE, null);
      tags.put(city, tag);
    }
    
    DikstraTag tag = new DikstraTag(start, 0.0f, null);
    tags.put(start, tag);
    open.add(tag);
  }
  
  void update(){
    if(open.size() > maxOpenSet){
      maxOpenSet = open.size();
    }
    if(closed.size() > maxClosedSet){
      maxClosedSet = closed.size();
    }
    if(tags.size() > maxTag){
      maxTag = tags.size();
    }
    

    if(!closed.contains(goal)){
      DikstraTag tag = open.poll();
      nodesExpanded++;
      if(tag == null){
       println("open.poll() returned null");
       return;
      }
      
      for(Road edge : tag.node.outgoing) {
        if(!closed.contains(edge.end)){
          DikstraTag next_tag = tags.get(edge.end);
          if(next_tag.cfs > edge.distance + tag.cfs){
            next_tag.cfs = edge.distance + tag.cfs;
            next_tag.edge = edge;
            tags.put(edge.end, next_tag);
            open.add(next_tag);
          }
        }
      }
      closed.add(tag.node);
    }
    
  } // end update
  
  List<Road> shortestPath(){
    if(closed.contains(goal)) {
      stopTime = System.currentTimeMillis();
      System.out.println("time until shortest path found: " + (stopTime - startTime));
      System.out.println("Nodes Expaned after shortest path found: " + nodesExpanded);
      System.out.println("maxOpenSet: " + maxOpenSet);
      System.out.println("maxClosedSet: " + maxClosedSet);
      System.out.println("maxTag: " + maxTag);
      ArrayList<Road> path = new ArrayList<Road>();
      
      DikstraTag tag = tags.get(goal);
      
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
    
      for(DikstraTag tag : open)
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
