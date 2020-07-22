package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.pgclient.PgPool;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.resteasy.annotations.jaxrs.PathParam;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import org.jboss.resteasy.annotations.SseElementType;
import java.net.URI;

@Path("messages")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MessageResource {

    @Inject
    @ConfigProperty(name = "myapp.schema.create", defaultValue = "true")
    boolean schemaCreate;


    @Inject
    PgPool client;

    @PostConstruct
    void config() {
        if (schemaCreate) {
            initdb();
        }
    }

    private void initdb() {
        client.query("DROP TABLE IF EXISTS messages").execute()
                .flatMap(r -> client.query("CREATE TABLE messages (id SERIAL PRIMARY KEY, text TEXT NOT NULL, sender TEXT, chatdata TEXT, chatid FLOAT(53), date FLOAT(53))").execute())
                .await().indefinitely();
    }

    @GET
    public Multi<Message> get() {
        return Message.findAll(client);
    }

    @GET
    @Path("name/{name}")
    public Multi<Message> getbyName(@PathParam String name) {
        return Message.findMessages(client, name);
    }

    @GET
    @Path("{id}")
    public Uni<Response> getSingle(@PathParam Long id) {
        return Message.findById(client, id)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("byname/{text}")
    public Uni<Response> getByName(@PathParam String text) {
        return Message.findByName(client, text)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("add/{id}/{text}/{sender}/{chatid}/{date}/{chatdata}")
    public Uni<Long> create(@PathParam Long id,@PathParam String text, @PathParam String sender,@PathParam Long chatid,@PathParam Long date, @PathParam String chatdata) {
        System.out.println(chatid+date);
        Message usr = new Message(id, text,  sender,  chatid,  date,    chatdata);
        return usr.save(client);
        

    }

    @GET
    @Path("update/{id}/{text}/{sender}/{chatid}/{date}/{chatdata}")
    public Uni<Response> update(@PathParam Long id,@PathParam String text, @PathParam String sender,@PathParam Long chatid,@PathParam Long date,@PathParam String chatdata) {
        Message usr = new Message( id, text,  sender,  chatid,  date,  chatdata);
        return usr.update(client)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(@PathParam Long id) {
        return Message.delete(client, id)
                .onItem().apply(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }


}