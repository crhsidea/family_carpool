package org.acme.reactive.crud;

public class Location {
    public double lat;
    public double lng;
    public String drivername;

    public Location(){

    }
    public Location(double la, double ln, String name){
        lat = la;
        lng = ln;
        drivername = name;
    }
}