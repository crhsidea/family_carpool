package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

import java.util.stream.StreamSupport;

public class User {

    public Long id;

    public String name;
    public String password;
    public double lat;
    public double lng;
    public String friends;
    public String userdata;



    public User() {
        // default constructo.
    }

    public User(String name, String password, double lat, double lng, String userdata, String friends) {
        this.name = name;
        this.password = password;
        this.lat = lat;
        this.lng = lng;
        this.userdata = userdata;
        this.friends = friends;
    }

    public User(Long id, String name, String password, double lat, double lng, String userdata, String friends) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.lat = lat;
        this.lng = lng;
        this.userdata = userdata;
        this.friends = friends;
    }

    public static Multi<User> findAll(PgPool client) {
        return client.query("SELECT * FROM users ORDER BY name ASC").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a User instance
                .onItem().apply(User::from);
    }

    public static Uni<User> findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT * FROM users WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public static Uni<User> findByName(PgPool client, String name) {
        return client.preparedQuery("SELECT * FROM users WHERE name = $1").execute(Tuple.of(name))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public Uni<Long> save(PgPool client) {
        return client.preparedQuery("INSERT INTO users (name, password, lat, lng, userdata, friends) VALUES ($1, $2, $3, $4, $5, $6) RETURNING (id)").execute(Tuple.of(name,password, lat, lng, userdata, friends ))
                .onItem().apply(pgRowSet -> pgRowSet.iterator().next().getLong("id"));
    }

    public Uni<Boolean> update(PgPool client) {
        return client.preparedQuery("UPDATE users SET name = $1, password = $2, lat = $3, lng = $4, userdata = $5, friends = $6 WHERE name = $1").execute(Tuple.of(name, password, lat, lng,  userdata, friends ))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public Uni<Boolean> updateCoords(PgPool client, String nam, double la, double ln) {
        return client.preparedQuery("UPDATE users SET lat = $2, lng = $3 WHERE name = $1").execute(Tuple.of(nam, la, ln ))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> delete(PgPool client, Long id) {
        return client.preparedQuery("DELETE FROM users WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    private static User from(Row row) {
        return new User(row.getLong("id"), row.getString("name"), row.getString("password"), row.getDouble("lat"), row.getDouble("lng"), row.getString("userdata"), row.getString("friends"));
    }
}