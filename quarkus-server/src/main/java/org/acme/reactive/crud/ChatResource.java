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

@Path("chats")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ChatResource {

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
        client.query("DROP TABLE IF EXISTS chats").execute()
                .flatMap(r -> client.query("CREATE TABLE chats (id SERIAL PRIMARY KEY, name TEXT NOT NULL, route TEXT, chatdata TEXT, lat FLOAT(53), lng FLOAT(53))").execute())
                .await().indefinitely();
    }

    @GET
    public Multi<Chat> get() {
        return Chat.findAll(client);
    }

    @GET
    @Path("{id}")
    public Uni<Response> getSingle(@PathParam Long id) {
        return Chat.findById(client, id)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("byname/{name}")
    public Uni<Response> getByName(@PathParam String name) {
        return Chat.findByName(client, name)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("name/{name}")
    public Multi<Chat> getbyName(@PathParam String name) {
        return Chat.findUserChats(client, name);
    }

    @GET
    @Path("add/{id}/{name}/{route}/{lat}/{lng}/{userdata}")
    public Uni<Long> create(@PathParam Long id,@PathParam String name, @PathParam String route,@PathParam double lat,@PathParam double lng, @PathParam String userdata) {
        System.out.println(lat+lng);
        Chat usr = new Chat(id, name,  route,  lat,  lng,    userdata);
        return usr.save(client);
        

    }

    @GET
    @Path("update/{id}/{name}/{route}/{lat}/{lng}/{userdata}")
    public Uni<Response> update(@PathParam Long id,@PathParam String name, @PathParam String route,@PathParam double lat,@PathParam double lng,@PathParam String userdata) {
        Chat usr = new Chat( id, name,  route,  lat,  lng,  userdata);
        return usr.update(client)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(@PathParam Long id) {
        return Chat.delete(client, id)
                .onItem().apply(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }


}