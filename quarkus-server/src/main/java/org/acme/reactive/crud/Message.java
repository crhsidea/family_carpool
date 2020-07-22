package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import io.vertx.mutiny.sqlclient.Row;
import io.vertx.mutiny.sqlclient.RowSet;
import io.vertx.mutiny.sqlclient.Tuple;

import java.util.stream.StreamSupport;

public class Message {

    public Long id;

    public String text;
    public String sender;
    public Long chatid;
    public Long date;
    public String chatdata;



    public Message() {
        // default constructo.
    }

    public Message(String text, String sender, Long chatid, Long date, String chatdata) {
        this.text = text;
        this.sender = sender;
        this.chatid = chatid;
        this.date = date;
        this.chatdata = chatdata;
    }

    public Message(Long id, String text, String sender, Long chatid, Long date, String chatdata) {
        this.id = id;
        this.text = text;
        this.sender = sender;
        this.chatid = chatid;
        this.date = date;
        this.chatdata = chatdata;
    }

    public static Multi<Message> findAll(PgPool client) {
        return client.query("SELECT * FROM messages ORDER BY text ASC").execute()
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Message instance
                .onItem().apply(Message::from);
    }

    public static Uni<Message> findById(PgPool client, Long id) {
        return client.preparedQuery("SELECT * FROM messages WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public static Multi<Message> findMessages(PgPool client, String chat) {
        return client.preparedQuery("SELECT * FROM messages WHERE chatid = $1").execute(Tuple.of(Integer.parseInt(chat)))
                // Create a Multi from the set of rows:
                .onItem().produceMulti(set -> Multi.createFrom().items(() -> StreamSupport.stream(set.spliterator(), false)))
                // For each row create a Route instance
                .onItem().apply(Message::from);
    }

    public static Uni<Message> findByName(PgPool client, String text) {
        return client.preparedQuery("SELECT * FROM messages WHERE text = $1").execute(Tuple.of(text))
                .onItem().apply(RowSet::iterator)
                .onItem().apply(iterator -> iterator.hasNext() ? from(iterator.next()) : null);
    }

    public Uni<Long> save(PgPool client) {
        return client.preparedQuery("INSERT INTO messages (text, sender, chatid, date, chatdata) VALUES ($1, $2, $3, $4, $5) RETURNING (id)").execute(Tuple.of(text,sender, chatid, date, chatdata ))
                .onItem().apply(pgRowSet -> pgRowSet.iterator().next().getLong("id"));
    }

    public Uni<Boolean> update(PgPool client) {
        return client.preparedQuery("UPDATE messages SET text = $1, sender = $2, chatid = $3, date = $4, chatdata = $5 WHERE text = $1").execute(Tuple.of(text, sender, chatid, date,  chatdata ))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    public static Uni<Boolean> delete(PgPool client, Long id) {
        return client.preparedQuery("DELETE FROM messages WHERE id = $1").execute(Tuple.of(id))
                .onItem().apply(pgRowSet -> pgRowSet.rowCount() == 1);
    }

    private static Message from(Row row) {
        return new Message(row.getLong("id"), row.getString("text"), row.getString("sender"), row.getLong("chatid"), row.getLong("date"), row.getString("chatdata"));
    }
}