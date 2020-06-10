### HELICS-cli Web Interface Package
The HELICS-cli Web Interface is a browser-compatible UI package for managing HELICS federations from within a normal 
web browser. 

#### Building Web Interface
The HELICS-cli Web Interface uses `npm` and `webpack` to compile and package a highly efficient and portable bundled 
library, compatible with modern browsers. 

`npm` is required to install dependencies and build the package. All other dependencies will be automatically retrieved 
and compiled on-the-fly. 

To build the HELICS-cli Web Interface, navigate to the `web` directory within the HELICS-cli repository and execute the 
following commands: 
- `npm install` 
- `npm run build`

The compiled release package will be assembled and located in the `dist` directory. This directory is loaded 
automatically by the HELICS-cli server runtime, and no additional actions are required. 

#### Development for Web Interface
Changes to the HELICS-cli should be performed on the source files located in the `src` directory, as changes to the 
`dist` directory will be lost on rebuild. Developers may also build the package in development mode using the command 
`npm run build-dev`.