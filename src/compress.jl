mutable struct RLCS
    rank::Int
    pool::Vector{String}
    counter::Int
end
function RLCS(rank::Int=63)
    @assert 0 <= rank <= 63
    return RLCS(rank, fill("", rank), 0)
end

function lcs(s1::AbstractString, s2::AbstractString)
    m, n = length(s1), length(s2)
    len, pos1, pos2 = 0, 0, 0
    dp = zeros(Int, m + 1, n + 1)
    for i in 1:m
        for j in 1:n
            if s1[i] == s2[j]
                dp[i+1, j+1] = dp[i, j] + 1
                if dp[i+1, j+1] > len
                    len = dp[i+1, j+1]
                    pos1 = i
                    pos2 = j
                end
            end
        end
    end
    return pos1-len+1:pos1, pos2-len+1:pos2
end

function lcs_zip(str, refer) # `str` and `refer` must not contain any uppercase letters
    rg1, rg2 = lcs(refer, str)
    if length(rg1) > 2 || (length(rg1) == 2 && rg1[1] == 1)
        b1, e1 = first(rg1), last(rg1)
        b2, e2 = first(rg2), last(rg2)
        l1 = e1 - b1 + 1
        if b1 <= 26 && l1 <= 26
            bc = b1 == 1 ? "" : 'A' + (b1 - 1)
            lc = 'A' + (l1 - 1)
            code = bc * lc
            return l1 - length(code), str[1:b2-1], code, str[e2+1:end]
        end
    end
    return 0, str, "", ""
end
function rlcs_zip(Z, str)
    ec(i) = i <= 11 ? ('0' + i - 2) : (i <= 37 ? 'a' + i - 12 : 'A' + i - 38)
    best = 0, str, "", ""
    for rk in 1:min(Z.rank, Z.counter)
        refer = Z.pool[(Z.counter - rk + 1) % Z.rank + 1]
        # @show rk refer
        l, h, c, t = lcs_zip(str, refer)
        rk > 1 && (l -= 2)
        # @show l
        if l > best[1]
            s = rk == 1 ? "" : 'A' * ec(rk)
            best = l, h, s * c, t
            # @show s
        end
        if length(str) - l < 2
            break
        end
    end
    Z.counter += 1
    zip_str = string(best[2], best[3], best[4])
    Z.rank > 0 && (Z.pool[Z.counter % Z.rank + 1] = str)
    return zip_str
end

function rlcs_unzip(Z, str)
    dc(c) = c <= '9' ? (c - '0' + 2) : (c >= 'a' ? c - 'a' + 12 : c - 'A' + 38)
    _b2 = findfirst(r"[A-Z]", str)
    if _b2 !== nothing
        _b2 = first(_b2)
        if str[_b2] != 'A'
            b2 = _b2
            rk = 1
        else
            b2 = first(findnext(r"[A-Z]", str, _b2 + 2))
            rk = dc(str[_b2 + 1])
        end
        refer = Z.pool[(Z.counter - rk + 1) % Z.rank + 1]
        b1 = str[b2] - 'A' + 1
        e2 = b2 + 1
        if e2 > length(str) || !('A' <= str[e2] <= 'Z')
            e2 = b2
            l1 = b1
            b1 = 1
        else
            l1 = str[e2] - 'A' + 1
        end
        e1 = b1 + l1 - 1
        str = string(str[1:_b2-1], refer[b1:e1], str[e2+1:end])
    end
    Z.counter += 1
    Z.rank > 0 && (Z.pool[Z.counter % Z.rank + 1] = str)
    return str
end