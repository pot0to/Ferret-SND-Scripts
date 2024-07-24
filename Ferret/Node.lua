function createNode(x, y, z)
    return {
        x = x,
        y = y,
        z = z
    }
end

function nodeToString(node)
    return ("%.1f"):format(node.x) .. ', ' .. ("%.1f"):format(node.y) .. ', ' .. ("%.1f"):format(node.z)
end
