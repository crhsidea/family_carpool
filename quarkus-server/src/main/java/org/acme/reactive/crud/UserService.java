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

import javax.enterprise.context.ApplicationScoped;
import java.time.Duration;

@ApplicationScoped
public class UserService {

    public Uni<String> greeting(String name) {
        return Uni.createFrom().item(name)
                .onItem().apply(n -> String.format("hello %s", name));
    }

/*  public Multi<User> locationStream(String name, Uni<User> user) {
        return Multi.createFrom().ticks().every(Duration.ofSeconds(1))
              .onItem().apply(n -> user)
              .transform().byTakingFirstItems(5);
      }*/
}