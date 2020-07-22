package org.acme.reactive.crud;

import io.smallrye.mutiny.Multi;
import io.smallrye.mutiny.Uni;
import io.smallrye.reactive.messaging.annotations.Broadcast;
import io.vertx.mutiny.pgclient.PgPool;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.resteasy.annotations.jaxrs.PathParam;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;

import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.json.bind.Jsonb;
import javax.json.bind.JsonbBuilder;
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
import org.reactivestreams.Publisher;

import org.acme.reactive.crud.User;

@ApplicationScoped
@Path("users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {

    @Inject
    @Broadcast
    @Channel
    ("locations")
    Emitter<String>locationsemitter;

    @Inject
    @ConfigProperty(name = "myapp.schema.create", defaultValue = "true")
    boolean schemaCreate;

    @Inject
    @Channel("locations")Publisher<String>locationsdata;


    @Inject
    PgPool client;

    @PostConstruct
    void config() {
        if (schemaCreate) {
            initdb();
        }
    }

    private void initdb() {
        client.query("DROP TABLE IF EXISTS users").execute()
                .flatMap(r -> client.query("CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT NOT NULL, password TEXT, userdata TEXT, lat FLOAT(53), lng FLOAT(53), friends TEXT)").execute())
                .await().indefinitely();
    }

    @GET
    public Multi<User> get() {
        return User.findAll(client);
    }

    @GET
    @Path("{id}")
    public Uni<Response> getSingle(@PathParam Long id) {
        return User.findById(client, id)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("/locstream")
    @Produces(MediaType.SERVER_SENT_EVENTS) 
    @SseElementType("text/plain") 
    public Publisher<String> stream(@PathParam String user) { 

        return locationsdata;
    }

    @GET
    @Path("byname/{name}")
    public Uni<Response> getByName(@PathParam String name) {
        return User.findByName(client, name)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }

    @GET
    @Path("add/{id}/{name}/{password}/{lat}/{lng}/{userdata}/{friends}")
    public Uni<Long> create(@PathParam Long id,@PathParam String name, @PathParam String password,@PathParam double lat,@PathParam double lng, @PathParam String userdata, @PathParam String friends) {
        System.out.println(lat+lng);
        User usr = new User(id, name,  password,  lat,  lng,    userdata, friends);
        return usr.save(client);
        

    }

    @GET
    @Path("update/{id}/{name}/{password}/{lat}/{lng}/{userdata}/{friends}")
    public Uni<Response> update(@PathParam Long id,@PathParam String name, @PathParam String password,@PathParam double lat,@PathParam double lng,@PathParam String userdata, @PathParam String friends) {
        User usr = new User( id, name,  password,  lat,  lng,  userdata, friends);
        return usr.update(client)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }

    @GET
    @Path("coords/{name}/{lat}/{lng}")
    public Uni<Response> updateCoords(@PathParam String name,@PathParam double lat,@PathParam double lng) {
        User usr = new User();
        return usr.updateCoords(client, name,   lat,  lng)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }
    
    @GET
    @Broadcast
    @Path("updatecoords/{name}/{lat}/{lng}")
    public void changeCoords(@PathParam String name,@PathParam double lat,@PathParam double lng) {
        Jsonb jsonb = JsonbBuilder.create();
        Location l = new Location(lat, lng, name);
        locationsemitter.send(jsonb.toJson(l));
    
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(@PathParam Long id) {
        return User.delete(client, id)
                .onItem().apply(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }


}