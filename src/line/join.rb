def replyJoin(event)
  Group.create({group_id: event["source"]["groupId"]})
end