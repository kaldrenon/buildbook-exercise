# buildbook-exercise

> BuildBook Take-home Coding Exercise - Andrew Fallows

## Your solution includes a README that explains how to use your application and a way to validate its output.

To run: clone the repo, navigate to the repo in a shell where `ruby` and the `bundle` gem are installed. Invoke:

```
bundle install
ruby buildbook.rb process in.json change.json out.json
```

To validate:

```
diff in.json out.json
```

## Your README describes what changes you would need to make in order to scale this application

> to handle very large input files and/or very large changes files. Just describe these changes — please do not implement a scaled-up version of the application.

The implementation I'm submitting uses `each` loops to iterate through the provided changes and modifies the entire object in-memory throughout its run. Nothing is persisted at any intermediate point.

To accommodate a larger scale, I would want to ingest the input file in chunks, rather than in one `.read()`, and persist it a database of some kind, so that the full size of the original source never needs to be in memory at once.

Similarly, I would ingest the changes file in chunks, and use a job queue (such as a tool like Sidekiq) to build up the record of changes that needed to be applied, and enable the system to execute them individually or in batches, piecemeal. With a limited number of changes allowed per job, the application would not hang on long loops like it would with my current implementation.

Lastly, in order to accommodate those changes, I would want to adjust the schema of the `changes.json` file. Rather than grouping changes by type, as I do now, I would require a single flat array of objects with a required "change_type" field, and the other required fields depending on which of the three types of change it represents. That schema would be far easier to ingest piecemeal or adapt into a different type of input stream like an API or a CRUD route.

## Your README includes any thoughts on design decisions you made that you think are appropriate.

I approach coding excercises for job applications with the appropriate gravity: which is to say, enough, but not a lot. 

I don't mean to sound flippant, but I also value expectation management: This isn't code that's ever going to get run or looked at once my interview process ends. It doesn't need to be robust or perfect, it just needs to prove that I know what I'm talking about and I know how to read requirements, think through a problem, and get going on a solution.

My implementation is very MVP; it does what it says on the tin and no more. I didn't spend time on things that are very important for code that will see light of day: testing, error handling, input validation, accessibility, etc are all out of scope. Likewise, certain considerations like code reusability are discarded: for a production application, I would likely have broken the three change loops into their own methods, in case there was another need for them in other functionality.

## Your README includes how long you spent on the project, and any other thoughts you might have or want to communicate.

I spent approximately 2 hours on this project, including the time I spent setting up an AWS Cloud9 workspace for the purpose of the task; I have wanted to experiment with remote development tools and environments for a while, and this felt like a good opportunity! I think I spent longer wrangling AWS setup than I did writing code, honestly. Roughly, I'd say 1 hour managing AWS, 45 minutes really coding, 15 minutes on testing, cleanup, and writing this readme.

Overall, I feel like I have successfully demonstrated that I know how to parse requirements and write basic Ruby code. I appreciate the limitations of coding exercises as a tool for really understanding a developer's knowledge and ability, and I look forward to speaking further with the team at Buildbook about myself and preparing to join the team!
