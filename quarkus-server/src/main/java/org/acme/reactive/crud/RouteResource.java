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

@Path("routes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class RouteResource {

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
        client.query("DROP TABLE IF EXISTS routes").execute()
                .flatMap(r -> client.query("CREATE TABLE routes (id SERIAL PRIMARY KEY, dates TEXT, users TEXT, addresses TEXT, routedata TEXT, lat FLOAT(53), lng FLOAT(53))").execute())
                .await().indefinitely();
    }

    @GET
    public Multi<Route> get() {
        return Route.findAll(client);
    }

    @GET
    @Path("name/{name}")
    public Multi<Route> getbyName(@PathParam String name) {
        return Route.findUserRoutes(client, name);
    }

    @GET
    @Path("rec/{lat}/{lng}")
    public Multi<Route> reccommend(@PathParam double lat, @PathParam double lng) {
        return Route.reccomend(client, lat, lng, .01);
    }


    @GET
    @Path("{id}")
    public Uni<Response> getSingle(@PathParam Long id) {
        return Route.findById(client, id)
                .onItem().apply(user -> user != null ? Response.ok(user) : Response.status(Status.NOT_FOUND))
                .onItem().apply(ResponseBuilder::build);
    }




    @GET
    @Path("add/{id}/{dates}/{users}/{addresses}/{lat}/{lng}/{routedata}")
    public Uni<Long> create(@PathParam Long id,@PathParam String dates, @PathParam String users, @PathParam String addresses,@PathParam double lat,@PathParam double lng, @PathParam String routedata) {
        System.out.println(lat+lng);
        Route usr = new Route(id, dates,  users, addresses,  lat,  lng,    routedata);
        return usr.save(client);
        

    }

    @GET
    @Path("update/{id}/{dates}/{users}/{addresses}/{lat}/{lng}/{routedata}")
    public Uni<Response> update(@PathParam Long id,@PathParam String dates, @PathParam String users,@PathParam String addresses,@PathParam double lat,@PathParam double lng,@PathParam String routedata) {
        Route usr = new Route( id, dates, users, addresses,  lat,  lng,  routedata);
        return usr.update(client)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }

    @GET
    @Path("updatedriver/{id}/{users}/{addresses}")
    public Uni<Response> updateDriver(@PathParam Long id,@PathParam String users,@PathParam String addresses) {
        Route usr = new Route( id, "", users, addresses,  0,  0,  "");
        return usr.updateDriver(client)
                .onItem().apply(updated -> updated ? Status.OK : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }

    @DELETE
    @Path("{id}")
    public Uni<Response> delete(@PathParam Long id) {
        return Route.delete(client, id)
                .onItem().apply(deleted -> deleted ? Status.NO_CONTENT : Status.NOT_FOUND)
                .onItem().apply(status -> Response.status(status).build());
    }


}