package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

import java.util.stream.StreamSupport;

public class Route {

    public Long id;

    public String dates;
    public String addresses;
    public String users;
    public double lat;
    public double lng;
    public String routedata;



    public Route() {
        // default constructo.
    }

    public Route(String dates,  String users,String addresses, double lat, double lng, String routedata) {
        this.dates = dates;
        this.addresses = addresses;
        this.lat = lat;
        this.lng = lng;
        this.routedata = routedata;
        this.users = users; 
    }

    public Route(Long id, String dates,  String users,String addresses,  double lat, double lng, String routedata) {
        this.id = id;
        this.dates = dates;
        this.addresses = addresses;
        this.lat = lat;
        this.lng = lng;
        this.routedata = routedata;
        this.users = users;
    }

    public static Multi<Route> findAll(PgPool client) {
        return client.query("SELECT * FROM routes ORDER BY dates ASC").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Route instance
                .onItem().apply(Route::from);
    }

    public static Uni<Route> findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT * FROM routes WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public static Multi<Route> findUserRoutes(PgPool client, String user) {
        return client.query("SELECT * FROM routes WHERE users LIKE '%"+user+"%' ORDER BY dates ASC ").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Route instance
                .onItem().apply(Route::from);
    }

    

    public static Multi<Route> reccomend(PgPool client, double lat, double lng, double tolerance) {
        return client.preparedQuery("SELECT * FROM routes WHERE  lat>$1 and lat<$2 and lng>$3 and lng<$4").execute(Tuple.of(lat-tolerance, lat+tolerance, lng-tolerance, lng+tolerance))
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Route instance
                .onItem().apply(Route::from);
    }

    public Uni<Long> save(PgPool client) {
        return client.preparedQuery("INSERT INTO routes (dates, addresses,users, lat, lng, routedata) VALUES ($1, $2, $3, $4, $5, $6) RETURNING (id)").execute(Tuple.of(dates,addresses,users, lat, lng, routedata ))
                .onItem().apply(pgRowSet -> pgRowSet.iterator().next().getLong("id"));
    }

    public Uni<Boolean> update(PgPool client) {
        return client.preparedQuery("UPDATE routes SET dates = $1, addresses = $2, lat = $3, lng = $4, routedata = $5, users = $6 WHERE dates = $1").execute(Tuple.of(dates, addresses, lat, lng,  routedata, users ))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public Uni<Boolean> updateDriver(PgPool client) {
        System.out.println(addresses);
        System.out.println(users);
        return client.preparedQuery("UPDATE routes SET addresses = $1 users = $2 WHERE id = $3").execute(Tuple.of(addresses, users, id))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> delete(PgPool client, Long id) {
        return client.preparedQuery("DELETE FROM routes WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    private static Route from(Row row) {
        return new Route(row.getLong("id"), row.getString("dates"),   row.getString("users"),row.getString("addresses"),row.getDouble("lat"), row.getDouble("lng"), row.getString("routedata"));
    }
}