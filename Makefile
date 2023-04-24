CC = nvcc

SRCS = plex.cu helpers/helper.cu helpers/checks.cu fileops/plexFile.cu 

OBJS = $(SRCS:.c=.o)

TARGET = Plex

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -rdc=true -o $@ $^

%.o: %.c
	$(CC) -rdc=true -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
