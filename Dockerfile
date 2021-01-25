FROM alpine:3.13 AS build

ARG PEPARSE_VER
ENV PEPARSE_VER=${PEPARSE_VER:-1.2.0}

ARG UTHENTICODE_VER
ENV UTHENTICODE_VER=${UTHENTICODE_VER:-1.0.4}

ARG WINCHECKSEC_VER
ENV WINCHECKSEC_VER=${WINCHECKSEC_VER:-3.0.1}

RUN apk add build-base gcc cmake openssl-dev git

WORKDIR /build/source

RUN git clone --depth 1 --branch "v${PEPARSE_VER}" \
  https://github.com/trailofbits/pe-parse

RUN git clone --depth 1 --branch "v${UTHENTICODE_VER}" \
  https://github.com/trailofbits/uthenticode

RUN git clone --depth 1 --branch "v${WINCHECKSEC_VER}" \
  https://github.com/trailofbits/winchecksec

WORKDIR /build

RUN cmake -B pe-parse -S source/pe-parse \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
  && cmake --build pe-parse \
  && cmake --build pe-parse --target install

RUN cmake -B uthenticode -S source/uthenticode \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_PREFIX_PATH=/build/pe-parse/lib/cmake/pe-parse \
  && cmake --build uthenticode \
  && cmake --build uthenticode --target install

RUN cmake -B winchecksec -S source/winchecksec \
    -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF \
    "-DCMAKE_PREFIX_PATH=/build/pe-parse/lib/cmake/pe-parse;/build/uthenticode/lib/cmake/uthenticode/" \
  && cmake --build winchecksec

FROM alpine:3.13 as run

RUN apk add libstdc++ libgcc jq

RUN mkdir /app
COPY --from=build /build/winchecksec/winchecksec /app/
COPY entrypoint.sh /app

ENTRYPOINT ["/app/entrypoint.sh"]
