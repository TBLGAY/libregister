FROM crystallang/crystal:1.13-alpine

RUN apk --update --no-cache add bash ca-certificates tzdata

WORKDIR /app/

COPY ./shard.yml ./shard.lock /app/

RUN shards install --frozen

COPY ./ /app/

RUN shards install --frozen
RUN crystal build --release --static -o /app/main src/main.cr

CMD ["/app/main"]