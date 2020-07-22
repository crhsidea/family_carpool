package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

import java.util.stream.StreamSupport;

public class Chat {

    public Long id;

    public String name;
    public String route;
    public double lat;
    public double lng;
    public String chatdata;



    public Chat() {
        // default constructo.
    }

    public Chat(String name, String route, double lat, double lng, String chatdata) {
        this.name = name;
        this.route = route;
        this.lat = lat;
        this.lng = lng;
        this.chatdata = chatdata;
    }

    public Chat(Long id, String name, String route, double lat, double lng, String chatdata) {
        this.id = id;
        this.name = name;
        this.route = route;
        this.lat = lat;
        this.lng = lng;
        this.chatdata = chatdata;
    }

    public static Multi<Chat> findAll(PgPool client) {
        return client.query("SELECT * FROM chats ORDER BY name ASC").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Chat instance
                .onItem().apply(Chat::from);
    }

    public static Multi<Chat> findUserChats(PgPool client, String user) {
        return client.query("SELECT * FROM chats WHERE chatdata LIKE '%"+user+"%'").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Route instance
                .onItem().apply(Chat::from);
    }

    public static Uni<Chat> findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT * FROM chats WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public static Uni<Chat> findByName(PgPool client, String name) {
        return client.preparedQuery("SELECT * FROM chats WHERE name = $1").execute(Tuple.of(name))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public Uni<Long> save(PgPool client) {
        return client.preparedQuery("INSERT INTO chats (name, route, lat, lng, chatdata) VALUES ($1, $2, $3, $4, $5) RETURNING (id)").execute(Tuple.of(name,route, lat, lng, chatdata ))
                .onItem().apply(pgRowSet -> pgRowSet.iterator().next().getLong("id"));
    }

    public Uni<Boolean> update(PgPool client) {
        return client.preparedQuery("UPDATE chats SET name = $1, route = $2, lat = $3, lng = $4, chatdata = $5 WHERE name = $1").execute(Tuple.of(name, route, lat, lng,  chatdata ))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> delete(PgPool client, Long id) {
        return client.preparedQuery("DELETE FROM chats WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    private static Chat from(Row row) {
        return new Chat(row.getLong("id"), row.getString("name"), row.getString("route"), row.getDouble("lat"), row.getDouble("lng"), row.getString("chatdata"));
    }
}