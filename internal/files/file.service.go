package files

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/transport/http/response"

	"github.com/gofrs/uuid"
)

type FileServiceImpl struct {
	DB     *infras.PostgresqlConn
	Config *configs.Config
}

func ProvideFileServiceImpl(db *infras.PostgresqlConn, c *configs.Config) *FileServiceImpl {
	return &FileServiceImpl{
		DB:     db,
		Config: c,
	}
}

type FileService interface {
	UploadFile(w http.ResponseWriter, r *http.Request) (path string, err error)
}

func (s *FileServiceImpl) UploadFile(w http.ResponseWriter, r *http.Request) (path string, err error) {
	if err = r.ParseMultipartForm(1024); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	uploadedFile, handler, err := r.FormFile("file")
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer uploadedFile.Close()

	newID, _ := uuid.NewV4()
	filename := fmt.Sprintf("%s%s", newID.String(), filepath.Ext(handler.Filename))
	baseDir := s.Config.App.File.Dir
	publicDir := s.Config.App.File.FotoProfile
	dir := filepath.Join(baseDir, publicDir)
	filePath := ""

	path = filepath.Join(filePath, filename)
	fileLocation := filepath.Join(dir, path)
	targetFile, err := os.OpenFile(fileLocation, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer targetFile.Close()

	if _, err = io.Copy(targetFile, uploadedFile); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	fmt.Println(fileLocation)
	log.Println("File " + path + " was Created")

	return
}
