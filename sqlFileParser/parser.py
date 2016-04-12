import re
var = re.compile(r"[^@]*@(?P<key>.+)@.*")  # [^@] means match anything except '@', * means 0-any times
com = re.compile(r"--.*")


def parse(file ="enrollment.sql"):
    fp = open(file, 'r')
    lines = [line.replace('\n', '').replace('\t', '').strip() for line in fp if (len(line) > 0) and line != '\n']
    buffer = []

    # remove redundant "spaces"
    for line in lines:
        tmp = line.split(" ")
        buffer.append(' '.join([word for word in tmp if len(word) > 0]))

    # Main parsing procedure
    res = {}
    k_cnt = 0
    i = 0
    while i < len(buffer):
        comment_match = com.match(buffer[i])
        if comment_match:
            var_match = var.match(buffer[i])
            if var_match:
                key = var_match.groupdict()['key']
                stmt = []
                i += 1
                while i < len(buffer) and not com.match(buffer[i]):
                    stmt.append(buffer[i])
                    i += 1
                res[key] = ' '.join(stmt)
            else:
                i += 1
        else:
            key = '_autokey:{0}'.format(k_cnt)
            k_cnt += 1
            stmt = []
            while i < len(buffer) and not com.match(buffer[i]):
                stmt.append(buffer[i])
                i += 1
            res[key] = ' '.join(stmt)

    return res


if __name__ == "__main__":
    res = parse()
    for i in range(1, 31):
        print(i, ': ', res[str(i)])